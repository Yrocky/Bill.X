//
//  MonthViewController.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/6.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController {

    private let monthView = MonthView()
    private let weekView = WeekView()
    private let contentView = MonthContentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(monthView)
        view.addSubview(weekView)
        view.addSubview(contentView)
        
        let directionGesture = DirectionGestureRecognizer.init(target: self, action: #selector(MonthViewController.onDirectionGestureAction))
        view.addGestureRecognizer(directionGesture)
        
        monthView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(76)
            make.top.equalTo(topLayoutGuide.snp.bottom)
        }
        weekView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(7.0)
            make.right.equalToSuperview().offset(-7.0)
            make.height.equalTo(60)
            make.top.equalTo(monthView.snp.bottom)
        }
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalTo(weekView)
            make.top.equalTo(weekView.snp.bottom)
            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-20)
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func onDirectionGestureAction(_ gesture : DirectionGestureRecognizer) {
        
        if (gesture.state == .changed) {
            
            var offset = gesture.offset;
            offset = offset > 0 ? pow(offset, 0.7) : -pow(-offset, 0.7);

            if (gesture.direction == .up) {
                self.contentView.transform = CGAffineTransform.init(translationX: 0, y: offset)
            }
            if (gesture.direction == .down) {
                self.contentView.transform = CGAffineTransform.init(translationX: 0, y: offset)
            }
            if (gesture.direction == .left) {
                self.contentView.transform = CGAffineTransform.init(translationX: offset, y: 0)
            }
            if (gesture.direction == .right) {
                self.contentView.transform = CGAffineTransform.init(translationX: offset, y: 0)
            }
        }else if(gesture.state == .ended ||
            gesture.state == .failed){
            
            let timingParameters = UISpringTimingParameters.init(dampingRatio: 0.125, initialVelocity: CGVector.init(dx: 0.3, dy: 0.3))
            let animator = UIViewPropertyAnimator.init(duration: 0.25, timingParameters: timingParameters)
            animator.addAnimations {
                self.contentView.transform = .identity
            }
            animator.startAnimation()
        }
    }

}
