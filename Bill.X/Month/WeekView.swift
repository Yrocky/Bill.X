//
//  WeekView.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/6.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class WeekView: UIStackView {

    private class _WeekItemView: UILabel {
        
        init(_ week : String ,_ isSun : Bool = false) {
            super.init(frame: .zero)
            
            self.text = week
            self.font = UIFont.billDINBold(17)
            self.textAlignment = .center
            self.backgroundColor = .clear
            self.textColor = !isSun ? .billBlack : .billOrange
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alignment = .fill
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.spacing = 7.0
        
        let weeks = ["S","M","T","W","T","F","S"]
        
        for (index,week) in weeks.enumerated(){
            
            let itemView = _WeekItemView.init(week, index == 0)
            self.addArrangedSubview(itemView)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
