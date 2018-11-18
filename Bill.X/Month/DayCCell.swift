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

class DayCCell: UICollectionViewCell ,BillRoundShadowViewEnable{

    var index : (Int,Int) = (0,0)
    
    private(set) var money = ""
    private(set) var day = ""
    
    var status : DayViewStatus{
        didSet{
            self.moneyLabel.isHidden = Double(self.money) == 0.0
            var normalImg : UIImage?
            var hilightImg : UIImage?
            switch status {
            case .empty:
                normalImg = UIImage.init(named: "bill_day_empty_normal")
                hilightImg = UIImage.init(named: "bill_day_empty_hl")
                self.dayLabel.attributedText = NSAttributedString.fillStyle(string: self.day, .billGray, 14)
            case .invalid:
                normalImg = UIImage.init(named: "bill_day_empty_normal")
                hilightImg = UIImage.init(named: "bill_day_empty_hl")
                self.moneyLabel.attributedText = NSAttributedString.strokeStyle(string: self.money, .billGray, 16)
                self.dayLabel.attributedText = NSAttributedString.strokeStyle(string: self.day, .billGray, 14)
            case .hasValue:
                normalImg = UIImage.init(named: "bill_day_has_value_normal")
                hilightImg = UIImage.init(named: "bill_day_has_value_hl")
                self.moneyLabel.attributedText = NSAttributedString.fillStyle(string: self.money, .white, 16)
                self.dayLabel.attributedText = NSAttributedString.fillStyle(string: self.day, .white, 14)
            case .today:
                normalImg = UIImage.init(named: "bill_day_today_normal")
                hilightImg = UIImage.init(named: "bill_day_today_hl")
                self.moneyLabel.attributedText = NSAttributedString.fillStyle(string: self.money, .white, 16)
                self.dayLabel.attributedText = NSAttributedString.fillStyle(string: self.day, .white, 14)
            }
            self.bgImageView.image = normalImg
            self.bgImageView.highlightedImage = hilightImg
        }
    }
    private let moneyLabel = UILabel()
    private let dayLabel = UILabel()
    private let bgImageView = UIImageView()
    
    override init(frame: CGRect) {
        self.status = .hasValue
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.backgroundView = nil
        self.contentView.backgroundColor = .clear

        self.clipsToBounds = false
        self.contentView.clipsToBounds = false
        
        contentView.addSubview(self.bgImageView)
        
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
        
        self.bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
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
    
    public func update(with dayEventWrap : BillDayEventWrap ,at year: Int , month : Int) {
        
        self.day = "\(dayEventWrap.day)"
        self.money = "\(dayEventWrap.totalBill)".billMoneyFormatter
        
        let isToday = Calendar.current.isToday(compareWith: dayEventWrap.year,
                                               month: dayEventWrap.month,
                                               day: dayEventWrap.day)
        
        let isCurrentMonth = dayEventWrap.year == year && dayEventWrap.month == month
        
        if isToday {
            self.status = .today
        }
        else if isCurrentMonth {
            
            if dayEventWrap.totalBill == 0.0 {
                self.status = .empty
            }else{
                self.status = .hasValue
            }
        }
        else{
            self.status = .invalid
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected{
                self.setHighlightBackground()
            }else{
                self.resetBackground()
            }
        }
    }
    private func setHighlightBackground() {
        self.bgImageView.isHighlighted = true
    }
    private func resetBackground() {
        self.bgImageView.isHighlighted = false
    }
    
}
