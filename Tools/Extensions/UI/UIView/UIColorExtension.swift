//
//  Created by admin on 16/4/26.
//  Copyright © 2016年 PT. All rights reserved.
//

import UIKit

let kThemeColor = UIColor(hexValue: 0x8b49f6)//UIColor(red:0.60, green:0.37, blue:0.79, alpha:1.00)

extension UIColor {
    
    // MARK: - 纬度常用颜色值，颜色名来自 sip，swift 3.0写法
    /**
     主题色
     */
    class var theme: UIColor {
        get {
            return UIColor(hexValue: 0x8b49f6)
        }
    }
    
    class var navigation: UIColor {
        get {
            return UIColor(hexValue: 0x694c99)
        }
    }
    
    class var border: UIColor {
        get {
            return UIColor(white: 0, alpha: 0.2)
        }
    }
    /**
     默认背景颜色
     */
    class var background: UIColor {
        get {
            return UIColor(hexValue: 0xEBEBEB)
        }
    }
    
    /**
     红色，0xED5564
     */
    class var textRed: UIColor {
        get {
            return UIColor(hexValue: 0xED5564)
        }
    }
    
    /**
     黄色，0xED5564
     */
    class var labelYellow: UIColor {
        get {
            return UIColor(hexValue: 0xFFE400)
        }
    }
    
    class var textYellow: UIColor {
        get{
            return UIColor(hexValue: 0xFF9B2B)
        }
    }
    
    /**
     绿色，0x3FAE29
     */
    class var textGreen: UIColor{
        get{
            return UIColor(hexValue: 0x3FAE29)
        }
    }
    
    /**
     文字颜色，0x313131
     */
    class var textBlack: UIColor {
        get {
            return UIColor(hexValue: 0x313131)
        }
    }
    
    /**
     文字颜色，0x646464
     */
    class var textDust: UIColor {
        get {
            return UIColor(hexValue: 0x646464)
        }
    }
    /**
     文字颜色 0x959595
     */
    class var textMist: UIColor {
        get {
            return UIColor(hexValue: 0x959595)
        }
    }
    /// 分割线颜色 0xe1e1e1
    class var zircon: UIColor {
        get {
            return UIColor(hexValue: 0xe1e1e1)
        }
    }
    
    /// 默认按钮不可用的颜色
    class var disEnable: UIColor {
        get {
            return UIColor(hexValue: 0xe5e5e5)
        }
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)    }
    
    //UIColor(hexValue: 0xEBEBEB)
    convenience init(hexValue:Int) {
        self.init(red:(hexValue >> 16) & 0xff, green:(hexValue >> 8) & 0xff, blue:hexValue & 0xff)
    }
    
    convenience init(hexValue:Int, alpha: Float) {
        
        let red   = CGFloat((hexValue >> 16) & 0xff)/255.0
        let green = CGFloat((hexValue >> 8) & 0xff)/255.0
        let blue  = CGFloat(hexValue & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
    
    class func defaultBackgroundColor() -> UIColor {
        return self.init(red: 0.922, green: 0.922, blue: 0.922, alpha: 1.0)
    }
    
    class func defaultTitleColor() -> UIColor {
        return UIColor(red: 31, green: 31, blue: 31)
    }
    
    class func defaultSubTitleColor() -> UIColor {
        return UIColor(red: 95, green: 95, blue: 95)
    }
    
    // 从 UIColor+Help 中移植的方法
    class func colorWithHex(_ hexValue: Int,alphaValue: Float) -> UIColor {
        return UIColor(colorLiteralRed: ((Float)((hexValue & 0xFF0000) >> 16))/255.0, green: ((Float)((hexValue & 0xFF00) >> 8))/255.0, blue: ((Float)(hexValue & 0xFF))/255.0, alpha: alphaValue);
    }
    
    class func colorWithHexSwift(_ hexValue: Int) -> UIColor {
        return UIColor.colorWithHex(hexValue, alphaValue: 1.0)
    }
    

}
