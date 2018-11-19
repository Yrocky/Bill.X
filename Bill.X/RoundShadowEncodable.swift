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
        view.layer.shadowRadius = 10
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
    
    public class func colorFromHex(_ hexString:String) -> UIColor {
        
        func clean(hexString: String) -> String {
            
            var cleanedHexString = String()
            
            // Remove the leading "#"
            if(hexString[hexString.startIndex] == "#") {
                let index = hexString.index(hexString.startIndex, offsetBy: 1)
                cleanedHexString = String(hexString[index...])
            }
            
            // TODO: Other cleanup. Allow for a "short" hex string, i.e., "#fff"
            
            return cleanedHexString
        }
        
        let cleanedHexString = clean(hexString: hexString)
        
        // If we can get a cached version of the colour, get out early.
        if let cachedColor = UIColor.getColorFromCache(cleanedHexString) {
            return cachedColor
        }
        
        // Else create the color, store it in the cache and return.
        let scanner = Scanner(string: cleanedHexString)
        
        var value:UInt32 = 0
        
        // We have the hex value, grab the red, green, blue and alpha values.
        // Have to pass value by reference, scanner modifies this directly as the result of scanning the hex string. The return value is the success or fail.
        if(scanner.scanHexInt32(&value)){
            
            // intValue = 01010101 11110111 11101010    // binary
            // intValue = 55       F7       EA          // hexadecimal
            
            //                     r
            //   00000000 00000000 01010101 intValue >> 16
            // & 00000000 00000000 11111111 mask
            //   ==========================
            // = 00000000 00000000 01010101 red
            
            //            r        g
            //   00000000 01010101 11110111 intValue >> 8
            // & 00000000 00000000 11111111 mask
            //   ==========================
            // = 00000000 00000000 11110111 green
            
            //   r        g        b
            //   01010101 11110111 11101010 intValue
            // & 00000000 00000000 11111111 mask
            //   ==========================
            // = 00000000 00000000 11101010 blue
            
            let intValue = UInt32(value)
            let mask:UInt32 = 0xFF
            
            let red = intValue >> 16 & mask
            let green = intValue >> 8 & mask
            let blue = intValue & mask
            
            // red, green, blue and alpha are currently between 0 and 255
            // We want to normalise these values between 0 and 1 to use with UIColor.
            let colors:[UInt32] = [red, green, blue]
            let normalised = normalise(colors)
            
            let newColor = UIColor(red: normalised[0], green: normalised[1], blue: normalised[2], alpha: 1)
            UIColor.storeColorInCache(cleanedHexString, color: newColor)
            
            return newColor
            
        }
            // We couldn't get a value from a valid hex string.
        else {
            print("Error: Couldn't convert the hex string to a number, returning UIColor.whiteColor() instead.")
            return UIColor.white
        }
    }
    private class func normalise(_ colors: [UInt32]) -> [CGFloat]{
        var normalisedVersions = [CGFloat]()
        
        for color in colors{
            normalisedVersions.append(CGFloat(color % 256) / 255)
        }
        
        return normalisedVersions
    }
    private static var hexColorCache = [String : UIColor]()
    
    private class func getColorFromCache(_ hexString: String) -> UIColor? {
        guard let color = UIColor.hexColorCache[hexString] else {
            return nil
        }
        
        return color
    }
    
    private class func storeColorInCache(_ hexString: String, color: UIColor) {
        
        if UIColor.hexColorCache.keys.contains(hexString) {
            return // No work to do if it is already there.
        }
        
        UIColor.hexColorCache[hexString] = color
    }
    
    private class func clearColorCache() {
        UIColor.hexColorCache.removeAll()
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

extension String {
    
    public var billMoneyFormatter : String{
        get {
            if self.hasSuffix(".0") {
                return self.components(separatedBy: ".").first!
            }
            return self
        }
    }
    
    public static func monthString(_ month : Int) -> String {
        let monshs = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec"]
        return monshs[month - 1]
    }
}

extension NSAttributedString{
    
    public class func strokeStyle(string : String, _ color : UIColor, _ fontSize : CGFloat) -> NSAttributedString{
        
        let style : [NSAttributedString.Key : Any] =
            [.backgroundColor:UIColor.clear,
             .font:UIFont.billDINBold(fontSize),
             .strokeColor:UIColor.gray,
             .strokeWidth:1/UIScreen.main.scale]
        return NSAttributedString.init(string: string,
                                       attributes: style)
    }
    
    
    public class func fillStyle(string : String, _ color : UIColor, _ fontSize : CGFloat) -> NSAttributedString{
        
        let style : [NSAttributedString.Key : Any] =
            [.foregroundColor:color,
             .font:UIFont.billDINBold(fontSize)]
        return NSAttributedString.init(string: string,
                                       attributes: style)
    }
}

extension UIImage {
    public class func imageWith(_ color : UIColor) -> UIImage {
        return self.imageWith(color, with: CGRect.init(origin: .zero, size: CGSize.init(width: 1, height: 1)))
    }
    
    public class func imageWith(_ color : UIColor , with frame : CGRect) -> UIImage {
        UIGraphicsBeginImageContext(frame.size)
        let cxt = UIGraphicsGetCurrentContext()
        cxt?.setFillColor(color.cgColor)
        cxt?.fill(frame)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension UIButton : BillRoundShadowViewEnable{
    public func setBackgroundImageWith(_ color : UIColor, for state : UIControl.State){
        self.setBackgroundImage(UIImage.imageWith(color), for: state)
    }
}

extension UIScreen {
    
    public var width : CGFloat{
        get{
            return self.bounds.width
        }
    }
    
    public var height : CGFloat{
        get{
            return self.bounds.height
        }
    }
}

extension UIDevice {
    
    public func isIphoneX() -> Bool {
        return UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ?
        CGSize.init(width: 1125, height: 2436).equalTo(UIScreen.main.currentMode!.size)
        : false
    }
    
    public func isIphoneXr() -> Bool {
        return UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ?
            CGSize.init(width: 828, height: 1792).equalTo(UIScreen.main.currentMode!.size)
            : false
    }
    public func isIphoneXs() -> Bool {
        return UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ?
            CGSize.init(width: 1125, height: 2436).equalTo(UIScreen.main.currentMode!.size)
            : false
    }
    public func isIphoneXsMax() -> Bool {
        return UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ?
            CGSize.init(width: 1242, height: 2688).equalTo(UIScreen.main.currentMode!.size)
            : false
    }
    public func isIphoneXShaped() -> Bool {
        return self.isIphoneX() || self.isIphoneXr() || self.isIphoneXs() || self.isIphoneXsMax()
    }
    
}
