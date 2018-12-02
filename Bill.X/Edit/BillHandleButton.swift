//
//  BillHandleButton.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/12/2.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class BillHandleButton : UIButton {
    
    enum HandleButtonType {
        case orange
        case white
    }
    
    private var handleButtonType : HandleButtonType = .orange
    
    public convenience init(with title : String) {
        self.init(with: title, type: .orange)
    }
    
    public convenience init(with title : String , type : HandleButtonType) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.handleButtonType = type
        switch type {
        case .orange:
            self.setBackgroundImage(UIImage.init(named: "bill_handle_button_orange_normal"), for: .normal)
            self.setBackgroundImage(UIImage.init(named: "bill_handle_button_orange_hl"), for: .highlighted)
            self.setBackgroundImage(UIImage.init(named: "bill_handle_button_orange_hl"), for: .disabled)
            self.setTitleColor(.white, for: .normal)
        case .white:
            self.setBackgroundImage(UIImage.init(named: "bill_handle_button_white_normal"), for: .normal)
            self.setBackgroundImage(UIImage.init(named: "bill_handle_button_orange_hl"), for: .highlighted)
            self.setBackgroundImage(UIImage.init(named: "bill_handle_button_orange_normal"), for: .disabled)
            self.setBackgroundImage(UIImage.init(named: "bill_handle_button_orange_normal"), for: .selected)
            self.setTitleColor(.billOrange, for: .normal)
            self.setTitleColor(.white, for: .highlighted)
            self.setTitleColor(.white, for: .disabled)
            self.setTitleColor(.white, for: .selected)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup(fontSize:19)
        self.addRoundShadowFor(self, cornerRadius: 10)
    }

    override var alignmentRectInsets: UIEdgeInsets{
        get {
            return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    public func setup(fontSize : CGFloat) {
        self.titleLabel?.font = UIFont.billDINBold(fontSize)
    }
    
    public func setup(title : String) {
        self.setTitle(title, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
