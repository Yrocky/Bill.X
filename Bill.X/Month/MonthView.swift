//
//  MonthView.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/10.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class MonthView: UIView {

    let monthLabel = UILabel()
    lazy var totalLabel : UILabel = {
        let l = UILabel()
        l.textAlignment = .right
        l.text = "￥4,756"
        l.font = UIFont.billPingFangSemibold(30)
        l.textColor = .billBlack
        return l
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        monthLabel.textColor = .billBlue
        monthLabel.textAlignment = .left
        monthLabel.font = UIFont.billDINBold(50)
        monthLabel.text = "Seq"
        addSubview(monthLabel)
        addSubview(self.totalLabel)
        
        monthLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.bottom.equalTo(-12)
        }
        totalLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(-12)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
