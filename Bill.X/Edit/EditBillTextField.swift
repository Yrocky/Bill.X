//
//  EditBillTextField.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/9.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class EditBillTextField: UITextField, BillRoundShadowViewEnable {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.borderStyle = .roundedRect
        self.clearButtonMode = .whileEditing
        self.backgroundColor = .red
        
        self.addRoundShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func becomeFirstResponder() -> Bool {
        
        textColor = .white
        backgroundColor = .red
        return true
    }
    override func resignFirstResponder() -> Bool {
        
        textColor = .gray
        backgroundColor = .white
        return true
    }
}
