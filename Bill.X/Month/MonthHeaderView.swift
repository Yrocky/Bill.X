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
        l.font = UIFont.billPingFangSemibold(30)
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
        monthLabel?.text = "Seq"
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
