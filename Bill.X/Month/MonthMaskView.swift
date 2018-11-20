//
//  MonthMaskView.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/20.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class MonthMaskView: UIView {

    var tapAction : (() -> ())?
    private var gradientLayer : CAGradientLayer!
    private var blurEffectView : UIVisualEffectView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientLayer = self.layer as? CAGradientLayer
        gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1)
        gradientLayer.colors = [UIColor.billWhite.withAlphaComponent(0.2).cgColor,
                                UIColor.billWhite.cgColor]
        gradientLayer.locations = [NSNumber.init(value: 0.2),
                                   NSNumber.init(value: 0.7)]
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.onTap))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func onTap() {
        if let action = self.tapAction {
            action()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}
