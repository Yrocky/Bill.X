//
//  BillMapView.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/12/2.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BillMapView: UIView {

    private var mapView : MKMapView?
    private var location : CLLocation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.mapView = MKMapView.init()
        self.mapView?.delegate = self
        addSubview(self.mapView!)
        mapView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        let clMgr = CLLocationManager.init()
        clMgr.requestLocation()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BillMapView : MKMapViewDelegate {
 
    
}
