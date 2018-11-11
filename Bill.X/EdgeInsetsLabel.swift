//
//  EdgeInsetsLabel.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/10.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class EdgeInsetsLabel: UILabel {

    public var edgeInsets : UIEdgeInsets = .zero

//    override setText(_ text : String){
//
//    }
    
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
