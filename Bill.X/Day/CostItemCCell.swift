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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .clear
//        
//        let longPressGesture = UILongPressGestureRecognizer.init(target: self,
//                                                             action: #selector(CostItemCCell.onLongPressAction))
//        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
//        longPressGesture.minimumPressDuration = 0.75
//        self.contentView.addGestureRecognizer(longPressGesture)
//        
        _contentView.backgroundColor = .white
        addRoundShadowFor(_contentView, cornerRadius: 16.0)
        
        self.contentView.addSubview(_contentView)
        
        self.costLabel.textColor = .white
        self.costLabel.edgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.costLabel.layer.cornerRadius = 12.0
        self.costLabel.text = "0"
        self.costLabel.font = UIFont.billDINBold(14)
        self.costLabel.backgroundColor = .billBlue
        self.costLabel.layer.masksToBounds = true
        self.costLabel.textAlignment = .center
        _contentView.addSubview(self.costLabel)
        
        self.usedLabel.textColor = .billBlack
        self.usedLabel.text = ""
        self.usedLabel.font = UIFont.billPingFang(14, weight: .light)
        self.usedLabel.textAlignment = .right
        _contentView.addSubview(self.usedLabel)
        
        _contentView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.costLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-3)
            make.centerY.equalToSuperview()
            make.bottom.equalTo(-4)
            make.top.equalTo(4)
            make.height.greaterThanOrEqualTo(24.0)
            make.width.greaterThanOrEqualTo(24.0).priority(.high)
        }
        
        self.usedLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.costLabel)
            make.left.equalTo(10)
            make.right.equalTo(self.costLabel.snp.left).offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(with eventWrap : BillEventWrap) {
        
        costLabel.text = "\(eventWrap.money)"
        usedLabel.text = eventWrap.usage
    }
    
    override var isHighlighted: Bool{
        didSet{
            _contentView.backgroundColor = isHighlighted ? .billWhite : .white
        }
    }
    
    
    @objc func onLongPressAction() {
        print("开始移动")
    }
}


extension DayCCell : UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
