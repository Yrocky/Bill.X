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
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onEventChange),
                                               name: Notification.Name.EKEventStoreChanged,
                                               object: nil)
    }
    
    @objc public func onEventChange() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
