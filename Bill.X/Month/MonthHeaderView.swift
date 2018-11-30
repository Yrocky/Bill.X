//
//  MonthView.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/10.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class MonthHeaderView: UIView {

    var monthLabel : UILabel?
    lazy var totalLabel : UILabel = {
        let l = UILabel()
        l.textAlignment = .right
        l.text = "￥0"
        l.font = UIFont.billDINBold(30)
        l.textColor = .billBlack
        return l
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        self.monthLabel = UILabel.init(frame: .zero)
        monthLabel?.textColor = .billBlue
        monthLabel?.textAlignment = .left
        monthLabel?.font = UIFont.billDINBold(48)
        monthLabel?.text = ""
        addSubview(monthLabel!)
        addSubview(self.totalLabel)
        
        monthLabel!.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(20)
        }
        totalLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(monthLabel!)
        }
    }
    
    func setupMoney(_ money : String) {
        
        let symbolStyle : [NSAttributedString.Key : Any] =
            [.foregroundColor:totalLabel.textColor,
             .font:UIFont.billDINBold(20)]
        let moneyStyle : [NSAttributedString.Key : Any] =
            [.foregroundColor:totalLabel.textColor,
             .font:UIFont.billDINBold(30)]
        
        let att = NSMutableAttributedString.init(string: "￥", attributes: symbolStyle)
        att.append(NSAttributedString.init(string: money, attributes: moneyStyle))
        totalLabel.attributedText = att
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
