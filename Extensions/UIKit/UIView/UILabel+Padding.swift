////
////  UILabel+Padding.swift
////  PaddingLabel
////
////  Created by Yilei He on 5/07/2016.
////  Copyright © 2016 lionhylra.com. All rights reserved.
////
import UIKit

@IBDesignable
public class YHPaddingLabel: UILabel {
    @IBInspectable public var paddingX: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable public var paddingY: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override public var intrinsicContentSize: CGSize {
        let resultOfSuper = super.intrinsicContentSize
        return CGSize(width: resultOfSuper.width + 2 * paddingX, height: resultOfSuper.height + 2 * paddingY)
    }

    public override func drawText(in rect: CGRect) {
        return super.drawText(in: rect.insetBy(dx: paddingX, dy: paddingY))
    }
}

//
//import UIKit
//import ObjectiveC
//
//private var paddingXAssociationKey: Int = 0
//private var paddingYAssociationKey: Int = 0
//extension UILabel {
//
//    var paddingX: CGFloat {
//        get{
//            return objc_getAssociatedObject(self, &paddingXAssociationKey) as? CGFloat ?? 0
//        }
//        set{
//            objc_setAssociatedObject(self, &paddingXAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
//        }
//    }
//    
//    
//    var paddingY: CGFloat {
//        get{
//            return objc_getAssociatedObject(self, &paddingYAssociationKey) as? CGFloat ?? 0
//        }
//        set{
//            objc_setAssociatedObject(self, &paddingYAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
//        }
//    }
//
//}
//
//
//
//extension UILabel {
//    
//    override open class func initialize() {
//        
//        /* Filter classes */
//        if self !== UILabel.self{
//            return
//        }
//        
//        let originalSelector = #selector(getter: UILabel.intrinsicContentSize)
//        let swizzledSelector = #selector(UILabel.swizzled_intrinsicContentSize)
//        
//        let originalMethod = class_getInstanceMethod(self, originalSelector)
//        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
//        
//        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
//        
//        if didAddMethod {
//            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod)
//        }
//        
//    }
//    
//    func swizzled_intrinsicContentSize() -> CGSize{
//        let size = self.swizzled_intrinsicContentSize()
//        return CGSize(width: size.width + 2*paddingX, height: size.height + 2*paddingY)
//    }
//}
