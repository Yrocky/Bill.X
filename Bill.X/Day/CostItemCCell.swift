//
//  CostItemView.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/9.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class CostItemCCell: UICollectionViewCell, BillRoundShadowViewEnable {

    private let moneyView = BillCostMoneyView()
    private let usedLabel = UILabel()
    private let bgImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .clear
        
        self.bgImageView.image = UIImage.init(named: "bill_day_item_bg_normal")
        self.bgImageView.highlightedImage = UIImage.init(named: "bill_day_item_bg_hl")
        self.contentView.addSubview(self.bgImageView)
        
        contentView.addSubview(self.moneyView)
        
        self.usedLabel.textColor = .billBlack
        self.usedLabel.text = ""
        self.usedLabel.font = UIFont.billPingFang(14, weight: .light)
        self.usedLabel.textAlignment = .right
        contentView.addSubview(self.usedLabel)
        
        self.bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        moneyView.snp.makeConstraints { (make) in
            make.right.equalTo(-4)
            make.centerY.equalToSuperview()
            make.bottom.equalTo(-4)
            make.top.equalTo(4)
            make.height.greaterThanOrEqualTo(24.0)
            make.width.greaterThanOrEqualTo(24.0).priority(.high)
        }
        
        self.usedLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.moneyView)
            make.left.equalTo(10)
            make.right.equalTo(self.moneyView.snp.left).offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(with eventWrap : BillEventWrap) {
        
        moneyView.costLabel.text = "\(eventWrap.money!)".billMoneyFormatter
        usedLabel.text = eventWrap.usage!
    }
    
    override var isHighlighted: Bool{
        didSet{
            bgImageView.isHighlighted = isHighlighted
        }
    }
}
