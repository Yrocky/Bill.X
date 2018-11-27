//
//  StickIndicatorView.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/22.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class StickIndicatorView: UIView {

    enum StickIndicatorDirection {
        case top
        case bottom
        case left
        case right
    }
    
    class DirectionView: UIView {
    
        var directionLayer : CAShapeLayer!
        var direction : StickIndicatorDirection?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.direction = .bottom
            self.directionLayer = self.layer as? CAShapeLayer
            self.directionLayer.fillColor = UIColor.clear.cgColor
            self.directionLayer.strokeColor = UIColor.billOrange.cgColor
            self.directionLayer.lineWidth = 2/UIScreen.main.scale
            self.directionLayer.strokeEnd = 1
            self.directionLayer.lineCap = .round
            self.directionLayer.lineJoin = .round
            self.directionLayer.opacity = 0
            self.directionLayer.path = self.createPathWithHeight(0.0)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func createPathWithHeight(_ height : CGFloat) -> CGPath {
            
            let selfWidth = frame.width
            let selfHeight = frame.height
            
            let bezierPath = UIBezierPath()
            
            var startPoint = CGPoint.zero
            var endPoint = CGPoint.zero
            var movePoint = CGPoint.zero
            
            if let direction = self.direction {
                
                switch direction{
                case .top:
                    endPoint = CGPoint.init(x: selfWidth, y: 0)
                    movePoint = CGPoint.init(x: selfWidth/2.0, y: height)
                case .bottom:
                    startPoint = CGPoint.init(x: 0, y: selfHeight)
                    endPoint = CGPoint.init(x: selfWidth, y: selfHeight)
                    movePoint = CGPoint.init(x: selfWidth/2.0, y: height)
                case .left:
                    startPoint = CGPoint.init(x: selfWidth, y: 0)
                    endPoint = CGPoint.init(x: selfWidth, y: selfHeight)
                    movePoint = CGPoint.init(x: (selfWidth - height), y: selfHeight/2.0)
                case .right:
                    endPoint = CGPoint.init(x: 0.0, y: selfHeight)
                    movePoint = CGPoint.init(x: height, y: selfHeight/2.0)
                }
            }
            bezierPath.move(to: startPoint)
            bezierPath.addLine(to: movePoint)
            bezierPath.addLine(to: endPoint)
            
            return bezierPath.cgPath
        }
        public func update(_ percent : CGFloat) {
            
            if percent <= 0 {
                
                directionLayer.path = self.createPathWithHeight(0.0)
                directionLayer.opacity = 0.0
            } else if percent > 0 && percent < 0.5 {
                
                directionLayer.path = self.createPathWithHeight(0.0)
                directionLayer.opacity = Float(percent * 2);
            } else if percent <= 1 {
                let currentPercent = percent - 0.5;
                let height = (direction == .left || direction == .right) ? frame.width : frame.height
                directionLayer.path = self.createPathWithHeight(currentPercent * height * 2)
                directionLayer.opacity = 1
            } else {
                let height = (direction == .left || direction == .right) ? frame.width : frame.height
                directionLayer.path = self.createPathWithHeight(height)
                directionLayer.opacity = 1;
            }
        }
        
        override class var layerClass: AnyClass {
            return CAShapeLayer.self
        }
    }
    
    let direction : StickIndicatorDirection
    private let indicatorInfoLabel : UILabel
    private let directionView : DirectionView
    private var progressTitle : String?
    private var fullTitle : String?
    
    init(with direction:StickIndicatorDirection) {
        
        self.direction = direction
        
        self.indicatorInfoLabel = UILabel()
        indicatorInfoLabel.textAlignment = .center
        indicatorInfoLabel.font = UIFont.billPingFang(12, weight: .regular)
        indicatorInfoLabel.textColor = .billGray
        indicatorInfoLabel.text = ""
        indicatorInfoLabel.numberOfLines = 0
        
        self.directionView = DirectionView()
        self.directionView.direction = direction
        
        super.init(frame: .zero)
        
        addSubview(indicatorInfoLabel)
        addSubview(directionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin = 5.0
        
        if direction == .top {
            
            directionView.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 30, height: 7))
                make.centerX.equalToSuperview()
                make.top.equalTo(indicatorInfoLabel.snp.bottom).offset(margin)
            }
            indicatorInfoLabel.snp.makeConstraints { (make) in
                make.height.greaterThanOrEqualTo(20)
                make.centerX.equalTo(directionView)
                make.top.equalToSuperview().offset(margin)
            }
        }
        else if direction == .left {
            
            indicatorInfoLabel.textAlignment = .right
            directionView.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 7, height: 20))
                make.right.equalToSuperview().offset(-margin)
                make.centerY.equalToSuperview()
            }
            indicatorInfoLabel.snp.makeConstraints { (make) in
                make.bottom.equalTo(directionView.snp.top).offset(-margin)
                make.right.equalTo(directionView)
                make.left.equalTo(0)
                make.height.greaterThanOrEqualTo(20)
            }
        }
        else if direction == .right {
            
            indicatorInfoLabel.textAlignment = .left
            directionView.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 7, height: 20))
                make.centerY.equalToSuperview()
                make.left.equalTo(margin)
            }
            
            indicatorInfoLabel.snp.makeConstraints { (make) in
                make.height.greaterThanOrEqualTo(20)
                make.bottom.equalTo(directionView.snp.top).offset(-margin)
                make.right.equalTo(0)
                make.left.equalTo(directionView)
            }
        }
        else if direction == .bottom {
            
            directionView.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 30, height: 7))
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(margin)
            }
            indicatorInfoLabel.snp.makeConstraints { (make) in
                make.top.equalTo(directionView.snp.bottom).offset(margin)
                make.centerX.equalTo(directionView)
                make.height.greaterThanOrEqualTo(20)
            }
        }
    }
    
    public func config(with title : String) {
        progressTitle = title
    }
    
    public func configFull(with title : String) {
        fullTitle = title
    }
    
    public func update(with percent : CGFloat) {
//        print("percent:\(percent)")
        indicatorInfoLabel.alpha = percent
        directionView.update(percent)
        if percent < 1 {
            indicatorInfoLabel.text = progressTitle
        } else {
            indicatorInfoLabel.text = fullTitle
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
