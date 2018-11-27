//
//  BillDayAnimator.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/26.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class BillDayPresentAnimator: NSObject ,UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 4.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        ///<固定格式
        containerView.addSubview(toView!)
        
        var sourceView : UIView?
        
        //        toView?.bounds = containerView.frame
        
        toView?.frame = sourceView!.convert(sourceView!.bounds, to: containerView)
        //        let scaleX = sourceView!.frame.width / containerView.frame.width
        //        let scaleY = sourceView!.frame.height / containerView.frame.height
        //        toView?.transform = CGAffineTransform.init(scaleX: scaleX, y: scaleY)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        let animator = UIViewPropertyAnimator.init(duration: duration, curve: .easeOut) {
            toView?.frame = containerView.bounds
            //            toView?.transform = .identity
        }
        animator.addCompletion { (position) in
            if position == .end {
                transitionContext.completeTransition(true)
            }
        }
        animator.startAnimation()
    }
}

class BillDayDismissAnimator: NSObject ,UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 4.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
    }
}
