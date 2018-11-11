//
//  DayView.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/6.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

enum DayViewStatus {
    case invalid
    case today
    case empty
    case hasValue
}

class DayView: UIView ,BillRoundShadowViewEnable{

    var index : (Int,Int) = (0,0)
    
    private(set) var money = ""
    private(set) var day = ""
    
    var status : DayViewStatus{
        didSet{
            self.moneyLabel.isHidden = false
            switch status {
            case .empty:
                self.moneyLabel.isHidden = true
                self.backgroundColor = .billWhite
                self.dayLabel.attributedText = NSAttributedString.fillStyle(string: self.day, .billGray, 16)
            case .invalid:
                self.moneyLabel.attributedText = NSAttributedString.strokeStyle(string: self.money, .billGray, 16)
                self.backgroundColor = .billWhite
                self.dayLabel.attributedText = NSAttributedString.strokeStyle(string: self.day, .billGray, 16)
            case .hasValue:
                self.moneyLabel.attributedText = NSAttributedString.fillStyle(string: self.money, .billWhite, 16)
                self.backgroundColor = .billBlue
                self.dayLabel.attributedText = NSAttributedString.fillStyle(string: self.day, .billWhite, 16)
            case .today:
                self.moneyLabel.attributedText = NSAttributedString.fillStyle(string: self.money, .billWhite, 16)
                self.backgroundColor = .billOrange
                self.dayLabel.attributedText = NSAttributedString.fillStyle(string: self.day, .billWhite, 16)
            }
        }
    }
    private let moneyLabel = UILabel()
    private let dayLabel = UILabel()
    
    override init(frame: CGRect) {
        self.status = .hasValue
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.billBlue
        addRoundShadow()
        
        moneyLabel.textAlignment = .center
        moneyLabel.textColor = .white
        moneyLabel.font = UIFont.billDINBold(16)
        moneyLabel.text = "25"
        addSubview(moneyLabel)
        
        dayLabel.textAlignment = .right
        dayLabel.textColor = .white
        dayLabel.font = UIFont.billDINBold(16)
        dayLabel.text = "18"
        addSubview(dayLabel)
        
        moneyLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(1)
            make.right.equalTo(-1)
        }
        dayLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.bottom.equalTo(-4)
            make.width.equalTo(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithMoney(_ money : String , day : String, status : DayViewStatus){
        self.money = money
        self.day = day
        self.status = status
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        switch self.status {
        case .empty:
            self.backgroundColor = .billWhiteHighlight
        case .hasValue:
            self.backgroundColor = .billBlueHighlight
        case .today:
            self.backgroundColor = .billOrangeHighlight
        case .invalid: break
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.resetBackground()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.resetBackground()
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if !self.bounds.contains((touches.first?.location(in: self))!) {
            self.resetBackground()
        }
    }
    private func resetBackground() {
        switch self.status {
        case .empty:
            self.backgroundColor = .billWhite
        case .hasValue:
            self.backgroundColor = .billBlue
        case .today:
            self.backgroundColor = .billOrange
        case .invalid: break
        }
    }
    
}
