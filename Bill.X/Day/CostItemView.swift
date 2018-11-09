//
//  CostItemView.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/9.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class CostItemView: UIControl, BillRoundShadowViewEnable {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addRoundShadowFor(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
