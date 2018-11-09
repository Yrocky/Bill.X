//
//  MonthCCell.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/9.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class MonthCCell: UICollectionViewCell,BillRoundShadowViewEnable {
    
    private let monthLabel = UILabel()
    private let totalLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.monthLabel.textColor = .red
        self.monthLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(self.monthLabel)
        
        self.totalLabel.textColor = .orange
        self.totalLabel.textAlignment = .center
        self.totalLabel.font = UIFont.systemFont(ofSize: 25)
        self.contentView.addSubview(self.totalLabel)
        
        addRoundShadowFor(self.contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func updateMonthTotalBill(_ total : NSInteger?) -> Void {
        if total != 0 {
            // 显示total，month移动到右下角
        } else {
            // 不显示total，month居中
        }
    }
}
