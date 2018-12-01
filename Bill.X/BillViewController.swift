//
//  BillViewController.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/18.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class BillViewController: UIViewController {

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(self) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .billWhite
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onEventChange),
                                               name: Notification.Name.EKEventStoreChanged,
                                               object: nil)
    }
    
    @objc public func onEventChange() {
        
//        DispatchQueue.main.async {
//            
//        }
    }
}

extension BillViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented.isKind(of: EditBillViewController.self) {
            return BillEditPresentAnimator()
        }
        return nil;
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed.isKind(of: EditBillViewController.self) {
            return BillEditDismissAnimator()
        }
        return nil
    }
}

