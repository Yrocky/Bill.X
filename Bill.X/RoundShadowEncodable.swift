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
        view.layer.shadowColor = UIColor.init(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 0.19).cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3.3
        view.layer.shadowOpacity = 1
    }
}
