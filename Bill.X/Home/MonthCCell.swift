//
//  MonthCCell.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/9.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import SnapKit

class MonthCCell: UICollectionViewCell,BillRoundShadowViewEnable {
    
    private let centerLabel = UILabel()
    private let cornerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor.white
        addRoundShadowFor(self.contentView, cornerRadius: 10.0)
        
        self.centerLabel.textAlignment = .center
        self.contentView.addSubview(self.centerLabel)
        
        self.cornerLabel.textColor = .orange
        self.cornerLabel.textAlignment = .right
        self.contentView.addSubview(self.cornerLabel)
        
        
        self.centerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.center.equalTo(self)
        }
        
        self.cornerLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-0)
            make.right.equalTo(self.snp.right).offset(-0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateMonthTotalBill(_ total : String, month : String) -> Void {
        if Double(total) != 0.0 {
            // 显示total，month移动到右下角
            centerLabel.attributedText = NSAttributedString.fillStyle(string: total, .billBlue, 50)

            cornerLabel.isHidden = false
            cornerLabel.attributedText = NSAttributedString.strokeStyle(string: month, .billWhite, 50)
        } else {
            // 不显示total，month居中
            centerLabel.attributedText = NSAttributedString.strokeStyle(string: month, .billBlue, 50)
            
            cornerLabel.text = nil
            cornerLabel.isHidden = true
        }
    }
}
