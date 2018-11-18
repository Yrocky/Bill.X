//
//  EdgeInsetsLabel.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/10.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class BillCostMoneyView: UIView {
    
    private let bgImageView = UIImageView()
    public var costLabel = EdgeInsetsLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.bgImageView.image = UIImage.init(named: "bill_day_item_money")
        self.addSubview(self.bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.costLabel.textColor = .white
        self.costLabel.edgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.costLabel.text = "0"
        self.costLabel.font = UIFont.billDINBold(14)
        self.costLabel.textAlignment = .center
        self.addSubview(self.costLabel)
        self.costLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EdgeInsetsLabel: UILabel {

    public var edgeInsets : UIEdgeInsets = .zero
    private let bgImageView = UIImageView()

//    override setText(_ text : String){
//
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = self.edgeInsets
        var rect = super.textRect(forBounds: CGRect.inset(bounds)(by: insets),
                                  limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: CGRect.inset(rect)(by: edgeInsets))
    }

}
