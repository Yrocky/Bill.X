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
