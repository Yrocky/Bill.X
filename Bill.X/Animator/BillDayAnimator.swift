//
//  BillDayAnimator.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/26.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

protocol BillDayPresentAnimatorProtocol : class{
    
    var sourceView : DayCCell? { get set }
}

class BillDayPresentAnimator: NSObject ,UIViewControllerAnimatedTransitioning{
    
    public weak var delegate : BillDayPresentAnimatorProtocol?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.55
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! DayViewController
        
        ///<固定格式
        containerView.addSubview(toView!)
        
        let sourceView = self.delegate?.sourceView
        if let cell = sourceView {
        
            cell.hideContent()
            toView?.frame = cell.convert(cell.bounds, to: containerView)
            toView?.alpha = 0
            
            let snapshotView = cell.snapshotView(afterScreenUpdates: true)
            snapshotView?.frame = toView!.frame
            snapshotView?.tag = 10001000
            containerView.addSubview(snapshotView!)
            
            let timeLabel = UILabel()
            timeLabel.text = cell.currentDayInfo()
            timeLabel.tag = 100010001
            timeLabel.frame = snapshotView?.bounds ?? .zero
            timeLabel.textAlignment = .left
            timeLabel.font = .billDINBold(50)
            timeLabel.textColor = .billBlue
            timeLabel.alpha = 0
            snapshotView?.addSubview(timeLabel)
            
            let moneyLabel = UILabel()
            moneyLabel.attributedText = cell.currentMoneyInfo()
            moneyLabel.alpha = 0
            moneyLabel.tag = 100010002
            moneyLabel.frame = snapshotView?.bounds ?? .zero
            moneyLabel.textColor = .billBlack
            snapshotView?.addSubview(moneyLabel)
        }
        
        let snapshotView = containerView.viewWithTag(10001000)
        let timeLabel = snapshotView?.viewWithTag(100010001) as? UILabel
        let moneyLabel = snapshotView?.viewWithTag(100010002) as? UILabel
        
        let (timeFrame ,moneyFrame) = toViewController.desLabelRect()
        let duration = self.transitionDuration(using: transitionContext)
        
        let animator = UIViewPropertyAnimator.init(duration: duration, curve: .easeOut) {
            
            toView?.alpha = 1
            toView?.frame = containerView.bounds

            timeLabel?.alpha = 1
            timeLabel?.frame = timeFrame.offsetBy(dx: 0, dy: UIDevice.current.statusBarHeight())
            
            moneyLabel?.alpha = 1
            moneyLabel?.frame = moneyFrame.offsetBy(dx: 0, dy: UIDevice.current.statusBarHeight())
            
            snapshotView?.frame = containerView.bounds
        }
        animator.addCompletion { (position) in
            if position == .end {
                toView?.isHidden = false
                transitionContext.completeTransition(true)
                snapshotView?.removeFromSuperview()
                toViewController.show()
            }
        }
        animator.startAnimation()
    }
}

class BillDayDismissAnimator: NSObject ,UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
    }
}
