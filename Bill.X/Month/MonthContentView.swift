//
//  MonthContentView.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/6.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class MonthContentView: UIStackView {

    private class _MonthContentHorizontalView: UIStackView {
        
        var lineNumber : Int = 0
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .orange
            self.alignment = .fill
            self.axis = .horizontal
            self.distribution = .fillEqually
            self.spacing = 7.0
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func add(_ dayView: DayView) {
            self.addArrangedSubview(dayView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        self.alignment = .fill
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 7.0
        
        for i in 0...5 {
            let horizontalView = _MonthContentHorizontalView()
            horizontalView.lineNumber = i
            self.addArrangedSubview(horizontalView)
            for j in 0...6 {
                let dayView = DayView()
                dayView.index = (i,j)
                var status : DayViewStatus = .invalid
                if i == 0 {
                    status = .invalid
                }
                if i == 1 {
                    status = .empty
                }
                if i == 2 {
                    status = .hasValue
                }
                if i == 3 {
                    status = .today
                }
                dayView.updateWithMoney("32",day: "3", status: status)
                horizontalView.add(dayView)
            }
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
