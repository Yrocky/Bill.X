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
        
        self.leftViewMode = .always
        self.leftView = UIView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 10, height: 0)))
        self.clearButtonMode = .whileEditing
        addRoundShadowFor(self, cornerRadius: 10)
        self.textColor = .gray
        self.tintColor = .billBlue
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func becomeFirstResponder() -> Bool {
        
        UIView.animate(withDuration: 0.25) {
            self.textColor = .white
            self.tintColor = .white
            self.backgroundColor = .billBlue
        }
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        
        UIView.animate(withDuration: 0.25) {        
            self.textColor = .gray
            self.tintColor = .billBlue
            self.backgroundColor = .white
        }
        return super.resignFirstResponder()
    }
}

class BillTextViewWrapView : UIView ,BillRoundShadowViewEnable {
    
    private(set) var textView : BillPlaceholderTextView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textView = BillPlaceholderTextView.init(frame: .zero, textContainer: nil)
        self.addSubview(self.textView!)
        self.textView?.snp.makeConstraints({ (make) in
            make.left.equalTo(10)
            make.top.equalTo(8)
            make.right.equalTo(-10)
            make.bottom.equalTo(-8)
        })
        self.backgroundColor = .white
        addRoundShadowFor(self, cornerRadius: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BillPlaceholderTextView: UITextView ,BillRoundShadowViewEnable{
    
    public var placeholder : String = "" {
        didSet{
            self.setNeedsDisplay()
        }
    }
    public var placeholderColor : UIColor = .lightGray
    
    private var placeholderLabel : UILabel?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.textColor = .gray
        self.tintColor = .billBlue
        self.backgroundColor = .clear
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BillPlaceholderTextView.onTextChange(_:)),
                                               name: UITextView.textDidChangeNotification, object: nil)
        self.contentInset = .zero
        self.textContainerInset = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onTextChange(_ noti : Notification?) {
        if self.placeholder.count == 0 {
            return
        }
        UIView.animate(withDuration: 0.25) {
            if self.text?.count == 0 {
                self.viewWithTag(999)?.alpha = 1.0
            }else{
                self.viewWithTag(999)?.alpha = 0.0
            }
        }
    }
    
    override var text: String!{
        didSet{
            self.onTextChange(nil)
        }
    }
    override func becomeFirstResponder() -> Bool {
        
        UIView.animate(withDuration: 0.25) {
            self.textColor = .white
            self.tintColor = .white
            self.superview?.backgroundColor = .billBlue
        }
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        
        UIView.animate(withDuration: 0.25) {
            self.textColor = .gray
            self.tintColor = .billBlue
            self.superview?.backgroundColor = .white
        }
        return super.resignFirstResponder()
    }
    
    override func draw(_ rect: CGRect) {
        
        if self.placeholder.count > 0 {
            let insets = self.textContainerInset
            if self.placeholderLabel == nil {
                let label = UILabel.init(frame: CGRect.init(x: insets.left,
                                                            y: insets.top,
                                                            width: bounds.width-insets.left-insets.right-10,
                                                            height: 1))
                label.lineBreakMode = .byWordWrapping
                label.font = self.font
                label.backgroundColor = .clear
                label.textColor = self.placeholderColor
                label.alpha = 0.0
                label.tag = 999
                self.addSubview(label)
                self.placeholderLabel = label
            }
            self.placeholderLabel?.text = self.placeholder
            self.placeholderLabel?.sizeToFit()
            self.placeholderLabel?.frame = CGRect.init(x: insets.left + 4,
                                                       y: insets.top,
                                                       width: bounds.width-insets.left-insets.right-10,
                                                       height: self.placeholderLabel!.frame.height)
            self.sendSubviewToBack(self.placeholderLabel!)
        }
        if self.text?.count == 0 && self.placeholder.count > 0 {
            self.viewWithTag(999)?.alpha = 1.0
        }
        super.draw(rect)
    }
}
