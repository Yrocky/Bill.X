//
//  EditBillInputAccessoryView.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/9.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

protocol EditBillInputAccessoryViewDelegate : class{
    
    func inputAccessoryViewDidOnCancel() -> Void
    func inputAccessoryViewDidOnSave() -> Void
}

class EditBillInputAccessoryView: UIView {

    private var cancelButton : UIButton?
    private var preButton : UIButton?
    private var nextButton : UIButton?
    private var saveButton : UIButton?
    
    public weak var delegate : EditBillInputAccessoryViewDelegate?
    
    public weak var preView : UIView?
    public weak var nextView : UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.layer.shadowColor = UIColor.init(red: 111.0/255.0, green: 115.0/255.0, blue: 118.0/255.0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize.init(width: 0, height: -1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        
        self.cancelButton = UIButton.init(type: .custom)
        self.cancelButton?.titleLabel?.font = UIFont.billPingFang(16, weight: .semibold)
        self.cancelButton?.setTitle("Cancel", for: .normal)
        self.cancelButton?.setTitleColor(UIColor.billBlack, for: .normal)
        self.cancelButton?.addTarget(self,
                                     action: #selector(self.onCancelAction),
                                     for: .touchUpInside)
        addSubview(self.cancelButton!)
        
        self.preButton = UIButton.init(type: .custom)
        self.preButton?.setImage(UIImage.init(named: "bill_edit_input_accessory_pre_normal"), for: .normal)
        self.preButton?.setImage(UIImage.init(named: "bill_edit_input_accessory_pre_disable"), for: .disabled)
        self.preButton?.addTarget(self,
                                     action: #selector(self.onPreAction),
                                     for: .touchUpInside)
        addSubview(self.preButton!)
        
        self.nextButton = UIButton.init(type: .custom)
        self.nextButton?.setImage(UIImage.init(named: "bill_edit_input_accessory_next_normal"), for: .normal)
        self.nextButton?.setImage(UIImage.init(named: "bill_edit_input_accessory_next_disable"), for: .disabled)
        self.nextButton?.addTarget(self,
                                  action: #selector(self.onNextAction),
                                  for: .touchUpInside)
        addSubview(self.nextButton!)
        
        self.saveButton = UIButton.init(type: .custom)
        self.saveButton?.titleLabel?.font = UIFont.billPingFang(16, weight: .semibold)
        self.saveButton?.setTitle("Save", for: .normal)
        self.saveButton?.setTitleColor(UIColor.billOrange, for: .normal)
        self.saveButton?.addTarget(self,
                                   action: #selector(self.onSaveAction),
                                   for: .touchUpInside)
        addSubview(self.saveButton!)
        
        self.cancelButton?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        })
        self.saveButton?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        })
        self.preButton?.snp.makeConstraints({ (make) in
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(self.preButton!.snp.height)
            make.trailing.equalTo(self.snp.centerX).offset(-20)
        })
        self.nextButton?.snp.makeConstraints({ (make) in
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(self.nextButton!.snp.height)
            make.leading.equalTo(self.snp.centerX).offset(20)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateHandleButtonStatus(for preButtonValid : Bool , nextButtonValid : Bool) {
        
        self.preButton?.isEnabled = preButtonValid
        self.nextButton?.isEnabled = nextButtonValid
    }
    
    public func updateSaveButtonStatus(valid : Bool) {
        self.saveButton?.isEnabled = valid
    }
    
    @objc func onCancelAction() {
        if let delegate = self.delegate {
            delegate.inputAccessoryViewDidOnCancel()
        }
    }
    @objc func onPreAction() {
        
        if let preView = self.preView {
            preView.becomeFirstResponder()
        }
    }
    @objc func onNextAction() {
        
        if let nextView = self.nextView {
            nextView.becomeFirstResponder()
        }
    }
    @objc func onSaveAction() {
        if let delegate = self.delegate {
            delegate.inputAccessoryViewDidOnSave()
        }
    }
}
