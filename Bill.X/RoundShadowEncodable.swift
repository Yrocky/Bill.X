//
//  RoundShadowEncodable.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/9.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import Foundation
import UIKit

protocol BillRoundShadowViewEnable {
    
    func addRoundShadowFor(_ view : UIView) -> Void;
    
    func addRoundShadowFor(_ view : UIView ,cornerRadius : CGFloat) -> Void;
}

extension BillRoundShadowViewEnable{
    
    func addRoundShadowFor(_ view : UIView) -> Void {
        self.addRoundShadowFor(view, cornerRadius: 4.0)
    }
    
    func addRoundShadowFor(_ view : UIView ,cornerRadius : CGFloat) -> Void{
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        view.layer.shadowColor = UIColor.init(red: 0.6, green: 0.3, blue: 0.8, alpha: 1).cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 6.0
    }
}
