//
//  EditBillView.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/9.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

//protocol EditBillViewControllerDelegate : class{
//
//    func editViewControllerDidModif(_ eventWrap : BillEventWrap) -> Void
//    func editViewControllerDidAdd(_ eventWrap : BillEventWrap) -> Void
//}

class EditBillViewController: UIViewController {

    private(set) var eventWrap : BillEventWrap?
    private(set) var contentView : UIView?
    private(set) var editMoney : EditBillTextField?
    private(set) var editUsage : EditBillTextField?
    private(set) var editNotes : BillTextViewWrapView?
    private(set) var editDate : BillHandleButton?
    private(set) var editLocation : BillHandleButton?
    private(set) var billInputAccessoryView : EditBillInputAccessoryView?
    
    private var dateView : UIDatePicker?
    private var locationView : UIView?
    
    private var date : Date?
    private var money : String = ""
    private var usage : String = ""
    private var note : String = ""
    
    public var canEditDate : Bool = false
    
    var keyboardHeight : CGFloat = (UIDevice.current.isIphoneXShaped() ? (216+34) : 216)
    
    deinit {
        print("EditBillViewController deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    public init(with eventWrap : BillEventWrap? , date : Date?) {
        self.eventWrap = eventWrap
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self,
                                                              action: #selector(self.onDismissAction)))
        
        self.contentView = UIView()
        self.contentView?.backgroundColor = .white
        self.contentView?.layer.cornerRadius = 10
        if #available(iOS 11.0, *) {
            if UIDevice.current.isIphoneXShaped() {
                self.contentView?.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
            }
        }
        view.addSubview(self.contentView!)
        
        self.editMoney = EditBillTextField.init(frame: .zero)
        self.editMoney?.placeholder = "Cost amount"
        self.editMoney?.text = self.money
        self.editMoney?.keyboardType = .numbersAndPunctuation
        self.editMoney?.font = UIFont.billDINBold(18)
        self.editMoney?.delegate = self
        self.contentView!.addSubview(self.editMoney!)
        
        self.editUsage = EditBillTextField.init(frame: .zero)
        self.editUsage?.placeholder = "Cost usage"
        self.editUsage?.text = usage
        self.editUsage?.font = UIFont.billPingFang(16, weight: .medium)
        self.editUsage?.delegate = self
        self.contentView!.addSubview(self.editUsage!)
        
        self.editDate = BillHandleButton.init(with: self.date!.ymd,
                                              type: .white)
        self.editDate?.addTarget(self,
                                 action: #selector(self.onEditDateAction(_:)),
                                 for: .touchUpInside)
        self.editDate?.setup(fontSize:17)
        self.contentView!.addSubview(self.editDate!)
        
        self.editLocation = BillHandleButton.init(with: "上海-闵行",
                                              type: .white)
        self.editLocation?.addTarget(self,
                                     action: #selector(self.onEditLocationAction(_:)),
                                     for: .touchUpInside)
        self.editLocation?.setup(fontSize:15)
        self.contentView!.addSubview(self.editLocation!)
        
        self.editNotes = BillTextViewWrapView.init(frame: .zero)
        self.editNotes?.textView?.placeholder = "Cost notes"
        self.editNotes?.textView?.text = note
        self.editNotes?.textView?.placeholderColor = self.editMoney?.value(forKeyPath: "_placeholderLabel.textColor") as! UIColor
        self.editNotes?.textView?.delegate = self
        self.editNotes?.textView?.font = UIFont.billPingFang(16, weight: .light)
        self.contentView!.addSubview(self.editNotes!)

        self.dateView = UIDatePicker.init()
        self.dateView?.datePickerMode = .date
        self.dateView?.isHidden = true
        self.dateView?.addTarget(self,
                                 action: #selector(self.onDateChangeAction(_:)),
                                 for: .valueChanged)
        self.dateView?.setDate(Date(), animated: true)
        self.dateView?.maximumDate = Date()
        self.contentView!.addSubview(self.dateView!)
        
        self.billInputAccessoryView = EditBillInputAccessoryView.init(frame: .zero)
        self.billInputAccessoryView?.isHidden = true
        self.billInputAccessoryView?.delegate = self
        self.contentView!.addSubview(self.billInputAccessoryView!)
        
        if let eventWrap = self.eventWrap {
            self.editMoney?.text = "\(eventWrap.money!)".billMoneyFormatter
            self.editUsage?.text = eventWrap.usage
            self.editNotes?.textView?.text = eventWrap.notes
            self.editDate?.setTitle(eventWrap.date.ymd, for: .normal)
        }
        
        self.contentView!.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
        self.editMoney?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(44)
            make.right.equalTo(self.contentView!.snp.centerX).offset(-5)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalTo(self.editNotes!.snp.top).offset(-10)
        })
        
        self.editUsage?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-16)
            make.height.top.equalTo(self.editMoney!)
            make.left.equalTo(self.contentView!.snp.centerX).offset(5)
        })
        self.editNotes?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.editMoney!)
            make.right.equalTo(self.editUsage!)
            make.top.equalTo(self.editMoney!.snp.bottom).offset(10)
            make.height.equalTo(60)
            make.bottom.equalTo(self.editDate!.snp.top).offset(-10)
        })
        self.editDate?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.editMoney!)
            make.right.equalTo(self.editMoney!)
            make.height.equalTo(self.editMoney!)
            make.top.equalTo(self.editNotes!.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-keyboardHeight)
        })
        self.editLocation?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.editUsage!)
            make.right.equalTo(self.editUsage!)
            make.height.equalTo(self.editDate!)
            make.top.bottom.equalTo(self.editDate!)
        })
        self.dateView?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.editMoney!)
            make.right.equalTo(self.editUsage!)
            make.top.equalTo(self.editDate!.snp.bottom).offset(20)
            make.bottom.equalTo(self.contentView!.safeAreaLayoutGuide)
        })
        self.billInputAccessoryView?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
            make.top.equalTo(self.editDate!.snp.bottom).offset(10)
        })

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onKeyboardShow(_:)),
                                               name:UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onKeyboardChangeFrame(_:)),
                                               name:UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onKeyboardHidden(_:)),
                                               name:UIResponder.keyboardWillHideNotification,
                                               object: nil)
        self.showKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public func showKeyboard() {
        if let editView = self.editMoney {
            editView.becomeFirstResponder()
        }
    }
    public func setup(for money : Double ,usage : String? , note : String?) {
        self.money = "\(money)"
        if let usage = usage {
            self.usage = usage
        }
        if let note = note {
            self.note = note
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onDismissAction() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    @objc func onEditDateAction(_ button:UIButton) {
        
        button.isEnabled = !button.isEnabled
        self.editLocation?.isEnabled = true
        self.view.endEditing(true)
        self.dateView?.isHidden = false
        self.locationView?.isHidden = true
    }
    @objc func onEditLocationAction(_ button:UIButton) {
        
        button.isEnabled = !button.isEnabled
        self.editDate?.isEnabled = true
        self.view.endEditing(true)
        self.dateView?.isHidden = true
        self.locationView?.isHidden = false
    }
    @objc func onDateChangeAction(_ datePicker : UIDatePicker) {
        print(datePicker.date)
        self.editDate?.setup(title: "\(datePicker.date.year)-\(datePicker.date.month)-\(datePicker.date.day)")
        self.date = datePicker.date
    }
}

extension EditBillViewController {
    
    @objc func onKeyboardShow(_ noti : Notification) {
        
        self.editDate?.isEnabled = true
        self.editLocation?.isEnabled = true
        self.onKeyboardChangeFrame(noti)
    }
    
    @objc func onKeyboardChangeFrame(_ noti : Notification) {
        let saveValid = self.editMoney!.text != nil && self.editUsage!.text != nil
        self.billInputAccessoryView?.updateSaveButtonStatus(valid: saveValid)
        
        if let userInfo = noti.userInfo {
            self.keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect).height + 10 + 54
            let duraction = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            UIView.animate(withDuration: duraction) {
                self.billInputAccessoryView?.isHidden = false
                self.editDate?.snp.updateConstraints({ (make) in
                    make.bottom.equalToSuperview().offset(-self.keyboardHeight)
                })
            }
        }
    }
    
    @objc func onKeyboardHidden(_ noti : Notification) {
        self.billInputAccessoryView?.isHidden = true
    }
}

extension EditBillViewController : UITextViewDelegate,UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.editMoney {
            self.billInputAccessoryView?.updateHandleButtonStatus(for: false,
                                                                  nextButtonValid: true)
            self.billInputAccessoryView!.preView = nil
            self.billInputAccessoryView?.nextView = self.editUsage
        }
        if textField == self.editUsage {
            self.billInputAccessoryView?.updateHandleButtonStatus(for: true,
                                                                  nextButtonValid: true)
            self.billInputAccessoryView?.preView = self.editMoney
            self.billInputAccessoryView?.nextView = self.editNotes?.textView
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.billInputAccessoryView?.updateHandleButtonStatus(for: true,
                                                              nextButtonValid: false)
        self.billInputAccessoryView?.preView = self.editUsage
        self.billInputAccessoryView!.nextView = nil
    }
}

extension EditBillViewController : EditBillInputAccessoryViewDelegate {
        
    func inputAccessoryViewDidOnCancel() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func inputAccessoryViewDidOnSave() {
        
        let money = self.editMoney!.text ?? "0"
        let usage = self.editUsage!.text ?? ""
        let notes = self.editNotes!.textView!.text ?? ""
        
        if money == "0" && usage.count == 0 {
            return
        }
        
        if self.eventWrap == nil {///create
            self.eventWrap = BillEventWrap.eventWrap(with: BillEventKitSupport.support,
                                                     money: Double(money) ?? 0.0,
                                                     usage: usage)
            self.eventWrap!.date = self.date ?? Date()
            self.eventWrap!.notes = notes
            BillEventKitSupport.support.addBillEvent(self.eventWrap!) { (finish) in
                if finish {
                    self.view.endEditing(true)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }else{///modif
            self.eventWrap!.money = Double(money) ?? 0.0
            self.eventWrap!.usage = usage
            self.eventWrap!.notes = notes
            BillEventKitSupport.support.updateBillEvent(self.eventWrap!) { (finish) in
                
                if finish {
                    self.onDismissAction()
                }
            }
        }
        
    }
}
