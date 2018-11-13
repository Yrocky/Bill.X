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

class DayView: UICollectionViewCell ,BillRoundShadowViewEnable{

    var index : (Int,Int) = (0,0)
    
    private(set) var money = ""
    private(set) var day = ""
    
    var status : DayViewStatus{
        didSet{
            self.moneyLabel.isHidden = Int(self.money) == 0
            switch status {
            case .empty:
                self.contentView.backgroundColor = .white
                self.dayLabel.attributedText = NSAttributedString.fillStyle(string: self.day, .billGray, 14)
            case .invalid:
                self.moneyLabel.attributedText = NSAttributedString.strokeStyle(string: self.money, .billGray, 16)
                self.contentView.backgroundColor = .white
                self.dayLabel.attributedText = NSAttributedString.strokeStyle(string: self.day, .billGray, 14)
            case .hasValue:
                self.moneyLabel.attributedText = NSAttributedString.fillStyle(string: self.money, .white, 16)
                self.contentView.backgroundColor = .billBlue
                self.dayLabel.attributedText = NSAttributedString.fillStyle(string: self.day, .white, 14)
            case .today:
                self.moneyLabel.attributedText = NSAttributedString.fillStyle(string: self.money, .white, 16)
                self.contentView.backgroundColor = .billOrange
                self.dayLabel.attributedText = NSAttributedString.fillStyle(string: self.day, .white, 14)
            }
        }
    }
    private let moneyLabel = UILabel()
    private let dayLabel = UILabel()
    
    override init(frame: CGRect) {
        self.status = .hasValue
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.backgroundView = nil
        self.contentView.backgroundColor = UIColor.white
        addRoundShadowFor(self.contentView)
        
        moneyLabel.textAlignment = .center
        moneyLabel.textColor = .white
        moneyLabel.font = UIFont.billDINBold(16)
        moneyLabel.text = "25"
        contentView.addSubview(moneyLabel)
        
        dayLabel.textAlignment = .right
        dayLabel.textColor = .white
        dayLabel.font = UIFont.billDINBold(14)
        dayLabel.text = "18"
        contentView.addSubview(dayLabel)
        
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
    
    public func update(with dayEventWrap : BillDayEventWrap) {
    
        self.day = "\(dayEventWrap.day)"
        self.money = "\(dayEventWrap.totalBill)"
        
        let isToday = Calendar.current.isToday(compareWith: dayEventWrap.year,
                                               month: dayEventWrap.month,
                                               day: dayEventWrap.day)
        let isCurrentMonth = Calendar.current.isCurrentMonth(compareWith: dayEventWrap.year,
                                                             month: dayEventWrap.month,
                                                             day: dayEventWrap.day)
        if isToday {
            self.status = .today
        }
        else if isCurrentMonth {
            
            if dayEventWrap.totalBill == 0 {
                self.status = .empty
            }else{
                self.status = .hasValue
            }
        }
        else{
            self.status = .invalid
        }
    }
    
    override var isHighlighted: Bool{
        didSet{
            if isHighlighted{
                self.setHighlightBackground()
            }else{
                self.resetBackground()
            }
        }
    }
    private func setHighlightBackground() {
        switch self.status {
        case .empty:
            contentView.backgroundColor = .billWhiteHighlight
        case .hasValue:
            contentView.backgroundColor = .billBlueHighlight
        case .today:
            contentView.backgroundColor = .billOrangeHighlight
        case .invalid: break
        }
    }
    private func resetBackground() {
        switch self.status {
        case .empty:
            contentView.backgroundColor = .white
        case .hasValue:
            contentView.backgroundColor = .billBlue
        case .today:
            contentView.backgroundColor = .billOrange
        case .invalid: break
        }
    }
    
}
