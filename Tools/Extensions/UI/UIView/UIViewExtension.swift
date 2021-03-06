//
//  UIViewExtension.swift
//  PTPark
//
//  Created by Chunlin on 2017/5/1.
//
//

import UIKit

extension UIView {
    class func loadNibWithClass<T: UIView>(_ view: T.Type) -> T {
        return Bundle.main.loadNibNamed(String(describing: view), owner: self, options: nil)?.last as! T
    }
    
    func applySimpleShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    func removeShadow(){
        self.layer.shadowColor = UIColor.clear.cgColor
    }
}
