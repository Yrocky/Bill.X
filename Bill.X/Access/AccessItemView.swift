//
//  AccessItemView.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/12/2.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class AccessItemView: UIView ,BillRoundShadowViewEnable{

    public enum AccessType {
        case arrow
        case checkboxOn
        case checkboxOff
    }
    
    public struct AccessItem {
        var title : String = ""
        var describe : String = ""
        var icon : String = ""
        var type : AccessType = .arrow
    }
    
    public var bTapBlock : (() -> ())?
    
    public var type : AccessType
    private let item : AccessItem
    
    private var iconImageView : UIImageView?
    private var titleLabel : UILabel?
    private var desLabel : UILabel?
    private var typeImageView : UIImageView?
    
    public init(With item : AccessItem) {
        self.item = item
        self.type = item.type
        super.init(frame: .zero)
        
        backgroundColor = .white
        self.iconImageView = UIImageView.init(image: UIImage.init(named: item.icon))
        self.addRoundShadowFor(self.iconImageView!, cornerRadius: 12)
        addSubview(self.iconImageView!)
        
        self.titleLabel = UILabel()
        self.titleLabel?.text = item.title
        self.titleLabel?.textAlignment = .left
        self.titleLabel?.font = UIFont.billPingFang(19, weight: .medium)
        self.titleLabel?.textColor = .billBlack
        addSubview(self.titleLabel!)
        
        self.desLabel = UILabel()
        self.desLabel?.text = item.describe
        self.desLabel?.numberOfLines = 2
        self.desLabel?.textAlignment = .left
        self.desLabel?.font = UIFont.billPingFang(14, weight: .regular)
        self.desLabel?.textColor = .billBlack
        addSubview(self.desLabel!)
        
        var typeImage : UIImage?
        switch self.type {
        case .arrow:
            typeImage = UIImage.init(named: "bill_access_arrow")
        case .checkboxOn:
            typeImage = UIImage.init(named: "bill_access_check_on")
        case .checkboxOff:
            typeImage = UIImage.init(named: "bill_access_check_off")
        }
        
        self.typeImageView = UIImageView()
        self.typeImageView?.image = typeImage
        addSubview(self.typeImageView!)
        
        self.iconImageView?.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize.init(width: 55, height: 55))
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        })
        self.titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.iconImageView!.snp.right).offset(15)
            make.top.equalTo(self).offset(15)
        })
        self.desLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.titleLabel!)
            make.top.equalTo(self.titleLabel!.snp.bottom).offset(8)
            make.bottom.equalTo(self).offset(-15)
            make.right.equalTo(-50)
        })
        
        self.typeImageView?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        })
        
        self.addRoundShadowFor(10)
        
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.onTapAction)))
    }
    
    func updateCheckout(with on : Bool) {
        
        if type == .checkboxOff && on{
            self.type = .checkboxOn
            let typeImage = UIImage.init(named: "bill_access_check_on")
            self.typeImageView?.image = typeImage
        }
    }
    
    @objc func onTapAction() {
        
        if self.type != .checkboxOn {
            if let bTapBlock = bTapBlock {
                bTapBlock()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
