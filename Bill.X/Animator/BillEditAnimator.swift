//
//  BillEditAnimator.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/18.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class BillEditPresentAnimator: NSObject ,UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        ///添加一个blur视图
        let effect = UIBlurEffect.init(style: .dark)
        let effectView = UIVisualEffectView.init(effect: effect)
        effectView.frame = containerView.bounds
        effectView.alpha = 0.8
        effectView.tag = 100100
        effectView.isHidden = true
        containerView.addSubview(effectView)
        
        ///<固定格式
        containerView.addSubview(toView!)
        
        toView?.frame.origin.y = containerView.frame.maxY
        
        let duration = self.transitionDuration(using: transitionContext)
        
        let animator = UIViewPropertyAnimator.init(duration: duration, curve: .easeOut) {
            toView?.frame.origin.y = containerView.frame.minY
            effectView.isHidden = false
        }
        animator.addCompletion { (position) in
            if position == .end {
                transitionContext.completeTransition(true)
            }
        }
        animator.startAnimation()
    }
}

class BillEditDismissAnimator: NSObject ,UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        
        let duration = self.transitionDuration(using: transitionContext)
        
        let animator = UIViewPropertyAnimator.init(duration: duration, curve: .easeInOut) {

            if let effectView = containerView.viewWithTag(100100) {
                effectView.alpha = 0.0
            }
            fromView?.frame.origin.y = containerView.frame.maxY
        }
        animator.addCompletion { (position) in
            if position == .end {
                if let effectView = containerView.viewWithTag(100100) {
                    effectView.removeFromSuperview()
                }
                transitionContext.completeTransition(true)
            }
        }
        animator.startAnimation()
    }
}
