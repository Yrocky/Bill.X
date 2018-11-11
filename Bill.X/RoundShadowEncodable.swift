//
//  RoundShadowEncodable.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/9.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import Foundation
import UIKit

protocol BillRoundShadowViewEnable {
    
    func addRoundShadow() -> Void;
    
    func addRoundShadowFor(_ view : UIView) -> Void;
    
    func addRoundShadowFor(_ view : UIView ,cornerRadius : CGFloat) -> Void;
}

extension BillRoundShadowViewEnable{
    
    func addRoundShadow() {
        self.addRoundShadowFor(self as! UIView)
    }
    
    func addRoundShadowFor(_ view : UIView) -> Void {
        self.addRoundShadowFor(view, cornerRadius: 4.0)
    }
    
    func addRoundShadowFor(_ view : UIView ,cornerRadius : CGFloat) -> Void{
        
        view.layer.cornerRadius = CGFloat(cornerRadius)
        view.layer.shadowColor = UIColor.init(red: 111.0/255.0, green: 115.0/255.0, blue: 118.0/255.0, alpha: 1).cgColor
        view.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
    }
}

extension UIColor{
    
    private class func colorWith(_ value : CGFloat) -> UIColor{
        return UIColor(red: value/255.0, green: value/255.0, blue: value/255.0, alpha: 1.0)
    }
    private class func colorWith(_ r : CGFloat,_ g : CGFloat,_ b : CGFloat) -> UIColor{
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    public class var billBlue: UIColor {
        return self.colorWith(66,136,230)
    }
    
    public class var billOrange: UIColor {
        return self.colorWith(255,94,98)
    }
    
    public class var billBlueHighlight: UIColor {
        return self.colorWith(52,107,179)
    }
    
    public class var billOrangeHighlight: UIColor {
        return self.colorWith(179,66,68)
    }
    
    public class var billBlack: UIColor {
        return self.colorWith(102)
    }
    
    public class var billGray: UIColor {
        return self.colorWith(155)
    }
    
    public class var billWhite: UIColor {
        return self.colorWith(242)
    }
    
    public class var billWhiteHighlight: UIColor {
        return self.colorWith(230)
    }
}

public enum FontWeight : String{
    case light = "Light"
    case bold = "Bold"
    case medium = "Medium"
    case semibold = "Semibold"
}

extension UIFont{
    
    public class func billDINBold(_ fontSize : CGFloat) -> UIFont{
        
        let font = UIFont.init(name: "DINAlternate-Bold", size: fontSize)
        return font!
    }
    
    public class func billPingFangSemibold(_ fontSize : CGFloat) -> UIFont{
        return self.billPingFang(fontSize, weight: .semibold)
    }
    
    public class func billPingFangMedium(_ fontSize : CGFloat) -> UIFont{
        return self.billPingFang(fontSize, weight: .medium)
    }
    
    public class func billPingFang(_ fontSize : CGFloat , weight : FontWeight) -> UIFont{
        let fontName = "PingFangSC-\(weight.rawValue)"
        let font = UIFont.init(name: fontName, size: fontSize)
        return font!
    }
    
}

extension NSAttributedString{
    
    public class func strokeStyle(string : String, _ color : UIColor, _ fontSize : CGFloat) -> NSAttributedString{
        
        let style : [NSAttributedStringKey : Any] =
            [.backgroundColor:UIColor.clear,
             .font:UIFont.billDINBold(fontSize),
             .strokeColor:UIColor.gray,
             .strokeWidth:1]
        return NSAttributedString.init(string: string,
                                       attributes: style)
    }
    
    
    public class func fillStyle(string : String, _ color : UIColor, _ fontSize : CGFloat) -> NSAttributedString{
        
        let style : [NSAttributedStringKey : Any] =
            [.foregroundColor:color,
             .font:UIFont.billDINBold(fontSize)]
        return NSAttributedString.init(string: string,
                                       attributes: style)
    }
}


