//
//  DayWasteContainerView.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/14.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class DayWasteContainerView: UIView {

    private var bordLineLayer = CAShapeLayer()
    private let tipLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        tipLabel.textAlignment = .center
        tipLabel.font = UIFont.billPingFang(16, weight: .medium)
        self.addSubview(tipLabel)
        
        bordLineLayer.cornerRadius = 10.0
        bordLineLayer.borderWidth = 2.0
        bordLineLayer.anchorPoint = .zero
        bordLineLayer.lineJoin = .round
        bordLineLayer.strokeColor = UIColor.clear.cgColor
        bordLineLayer.lineDashPattern = [NSNumber.init(value: 60),NSNumber.init(value: 5)]
        bordLineLayer.lineDashPhase = 1
        layer.addSublayer(bordLineLayer)
        self.makeGarbage(highlight: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bordLineLayer.frame = bounds
        tipLabel.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func makeGarbage(highlight : Bool) {
        if highlight {
            bordLineLayer.borderColor = UIColor.billOrange.cgColor
            backgroundColor = .billGray
            tipLabel.textColor = .billOrange
            tipLabel.text = "Release to remove"
        }else{
            bordLineLayer.borderColor = UIColor.billGray.cgColor
            backgroundColor = .white
            tipLabel.textColor = .billGray
            tipLabel.text = "Drop here remove"
        }
    }
}

extension DayWasteContainerView {
    
}
