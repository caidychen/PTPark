//
//  UIButton+Image.swift
//  PTPark
//
//  Created by soso on 2017/4/19.
//
//

import UIKit

extension UIButton {
    
    func set(_ normal: (title: String?, titleColor: UIColor?), _ highlighted: (title: String, titleColor: UIColor?)) -> Void {
        self.setTitle(normal.title, for: .normal)
        self.setTitleColor(normal.titleColor, for: .normal)
        self.setTitle(highlighted.title, for: .highlighted)
        self.setTitleColor(highlighted.titleColor, for: .highlighted)
    }
    
    func set(_ normal: (title: String?, backgroundImage: UIImage?), _ highlighted: (title: String, backgroundImage: UIImage?)) -> Void {
        self.setTitle(normal.title, for: .normal)
        self.setBackgroundImage(normal.backgroundImage, for: .normal)
        self.setTitle(highlighted.title, for: .highlighted)
        self.setBackgroundImage(highlighted.backgroundImage, for: .highlighted)
    }
    
    func set(_ normal: (image: UIImage, backgroundImage: UIImage?), _ highlighted: (image: UIImage, backgroundImage: UIImage?)) -> Void {
        self.setImage(normal.image, for: .normal)
        self.setBackgroundImage(normal.backgroundImage, for: .normal)
        self.setImage(highlighted.image, for: .highlighted)
        self.setBackgroundImage(highlighted.backgroundImage, for: .highlighted)
    }
    
    func set(title: String?, imageName: String) {
        let image = UIImage(named: imageName)
        self.setTitle(title, for: .normal)
        self.setImage(image, for: .normal)
    }
}
