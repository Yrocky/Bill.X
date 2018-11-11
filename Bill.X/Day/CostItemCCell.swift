//
//  CostItemView.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/9.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class CostItemCCell: UICollectionViewCell, BillRoundShadowViewEnable {

    private let _contentView = UIView()
    private let costLabel = EdgeInsetsLabel()
    private let usedLabel = UILabel()
    lazy private var deleteButton : UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImageWith(.red, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .orange
        
        _contentView.backgroundColor = .white
        addRoundShadowFor(_contentView, cornerRadius: 16.0)
        
        self.contentView.addSubview(_contentView)
        
        self.costLabel.textColor = .white
        self.costLabel.edgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.costLabel.layer.cornerRadius = 12.0
        self.costLabel.text = "5"
        self.costLabel.font = UIFont.billDINBold(14)
        self.costLabel.backgroundColor = .billBlue
        self.costLabel.layer.masksToBounds = true
        self.costLabel.textAlignment = .center
        _contentView.addSubview(self.costLabel)
        
        self.usedLabel.textColor = .billBlack
        self.usedLabel.text = "早餐"
        self.usedLabel.font = UIFont.billPingFang(14, weight: .light)
        self.usedLabel.textAlignment = .right
        _contentView.addSubview(self.usedLabel)
        
        self.contentView.addSubview(self.deleteButton)
        
        _contentView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.costLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-3)
            make.centerY.equalToSuperview()
            make.bottom.equalTo(-4)
            make.top.equalTo(4)
            make.height.greaterThanOrEqualTo(24.0)
            make.width.greaterThanOrEqualTo(24.0)
            make.left.equalTo(self.usedLabel.snp.right).offset(10)
        }
        
        self.usedLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.costLabel)
            make.left.equalTo(10)
            make.right.equalTo(self.costLabel.snp.left).offset(-10)
        }
        
        self.deleteButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 20, height: 20))
            make.centerY.equalTo(_contentView.snp.top).offset(4)
            make.centerX.equalTo(_contentView.snp.leading).offset(4)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool{
        didSet{
            _contentView.backgroundColor = isHighlighted ? .billWhite : .white
        }
    }
    
}
