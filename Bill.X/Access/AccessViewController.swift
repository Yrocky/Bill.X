//
//  AccessViewController.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/12/2.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import CoreLocation

class AccessViewController: UIViewController {

    private var titleLabel : UILabel?
    private var desLabel : UILabel?
    private var shortcutView : AccessItemView?
    private var eventKitView : AccessItemView?
    private var locationView : AccessItemView?
    private var goButton : BillHandleButton?
    private var locationMgr : CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .billWhite
        
        let eventKitAccess = BillEventKitSupport.support.accessAuthed
        
        self.locationMgr = CLLocationManager()
        self.locationMgr?.delegate = self
        
        let locationAccess = self.checkLocationAccessStatus()
        
        self.titleLabel = UILabel()
        titleLabel?.text = "Bill.X"
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.billDINBold(50)
        titleLabel?.textColor = UIColor.billBlue
        view.addSubview(titleLabel!)
        
        self.desLabel = UILabel()
        desLabel?.text = "让记账成为一件简单的事"
        desLabel?.textAlignment = .center
        desLabel?.font = UIFont.billPingFang(20, weight: .regular)
        desLabel?.textColor = UIColor.billDesBlue
        view.addSubview(desLabel!)
        
        let shortcutItem = AccessItemView.AccessItem.init(title: "捷径",
                                                       describe: "提供一个捷径操作，方便记账",
                                                       icon: "bill_access_shortcut",
                                                       type: .arrow)
        self.shortcutView = AccessItemView.init(With: shortcutItem)
        shortcutView?.tag = 100
        shortcutView?.bTapBlock = {
            let url = URL.init(string: "https://www.icloud.com/shortcuts/7b3058eb8cbe4d0dae10e618e7476a22")
            UIApplication.shared.open(url!,
                                      options: [:], completionHandler: nil)
        }
        view.addSubview(self.shortcutView!)
        
        let eventKitItem = AccessItemView.AccessItem.init(title: "访问日历",
                                                          describe: "需要授权访问日历，以保存记账数据",
                                                          icon: "bill_access_eventKit",
                                                          type: eventKitAccess ? .checkboxOn : .checkboxOff)
        self.eventKitView = AccessItemView.init(With: eventKitItem)
        eventKitView?.tag = 101
        self.eventKitView?.bTapBlock = {
            print("tap event")
            BillEventKitSupport.support.checkEventStoreAccessForCanendar { (accessGrand) in
                self.eventKitView?.updateCheckout(with: accessGrand)
                self.checkGoButtonStatus()
                if BillEventKitSupport.support.accessDenied {
                    print("明确拒绝了授权，event")
                }
            }
        }
        view.addSubview(self.eventKitView!)
        
        let locationItem = AccessItemView.AccessItem.init(title: "获取定位",
                                                          describe: "需要授权访问定位，在记账的时候记录地理位置",
                                                          icon: "bill_access_location",
                                                          type: locationAccess ? .checkboxOn : .checkboxOff)
        self.locationView = AccessItemView.init(With: locationItem)
        locationView?.tag = 102
        self.locationView?.bTapBlock = {
            
            let locationStatus = CLLocationManager.authorizationStatus()
            if locationStatus == .denied || locationStatus == .restricted {
                print("明确拒绝了授权，location")
            }else{
                self.locationMgr?.requestWhenInUseAuthorization()
            }
        }
        view.addSubview(self.locationView!)
        
        self.goButton = BillHandleButton.init(with: "开启记账之旅")
        self.goButton?.titleLabel?.font = UIFont.billPingFang(18, weight: .regular)
        goButton?.addTarget(self,
                            action: #selector(self.onGoButtonAction), for: .touchUpInside)
        view.addSubview(self.goButton!)
        
        self.titleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
        })
        
        self.desLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel!.snp.bottom).offset(10)
        })
        
        self.shortcutView?.snp.makeConstraints({ (make) in
            make.top.equalTo(desLabel!.snp.bottom).offset(40)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.greaterThanOrEqualTo(80)
        })
        
        let offset = UIDevice.current.isIphoneXShaped() ? 30 : 20
        self.eventKitView?.snp.makeConstraints({ (make) in
            make.top.equalTo(shortcutView!.snp.bottom).offset(offset)
            make.left.equalTo(shortcutView!)
            make.right.equalTo(shortcutView!)
            make.height.greaterThanOrEqualTo(80)
        })
        self.locationView?.snp.makeConstraints({ (make) in
            make.top.equalTo(eventKitView!.snp.bottom).offset(offset)
            make.left.equalTo(eventKitView!)
            make.right.equalTo(eventKitView!)
            make.height.greaterThanOrEqualTo(80)
        })
        
        self.goButton?.snp.makeConstraints({ (make) in
            make.left.equalTo(35)
            make.height.equalTo(50)
            make.right.equalTo(-35)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        })
        
        view.subviews.filter { (subView) -> Bool in
            return subView.isKind(of: AccessItemView.self)
            }.forEach { (accessView) in
                accessView.transform = CGAffineTransform.init(translationX: 0, y: 200)
                accessView.alpha = 0.6
                
                let timingParameters = UISpringTimingParameters.init(mass: 1,
                                                                     stiffness: 261,
                                                                     damping: 16,
                                                                     initialVelocity: CGVector.init(dx: 0.3, dy: 0.3))
                let animator = UIViewPropertyAnimator.init(duration: 0.4, timingParameters: timingParameters)
                animator.addAnimations({
                    accessView.alpha = 1
                    accessView.transform = .identity
                }, delayFactor: (CGFloat(Double(accessView.tag - 100) * 0.08)))
                animator.startAnimation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkGoButtonStatus()
    }
    func checkLocationAccessStatus() -> Bool {
        let locationStatus = CLLocationManager.authorizationStatus()
        return locationStatus == .authorizedAlways ||
            locationStatus == .authorizedWhenInUse
    }
    
    @objc func onGoButtonAction() {
        
        //
        if let window = UIApplication.shared.delegate!.window{
            let rootViewController = HomeViewController()
            window?.rootViewController = rootViewController
            window?.makeKeyAndVisible()
        }
    }
    
    func checkGoButtonStatus() {
        
        self.goButton?.isEnabled = self.locationView?.type == .checkboxOn && self.eventKitView?.type == .checkboxOn
    }
}

extension AccessViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        
        DispatchQueue.main.async {
            let locationAccess = status == .authorizedAlways ||
                status == .authorizedWhenInUse
            self.locationView?.updateCheckout(with: locationAccess)
            
            self.checkGoButtonStatus()
        }
    }
}
