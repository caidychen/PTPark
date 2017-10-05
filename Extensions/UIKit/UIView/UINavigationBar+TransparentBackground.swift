//
//  UINavigationBar+alpha+color.swift
//  Swift3Project
//
//  Created by Yilei He on 7/11/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension UINavigationBar {

    func setBackgroundTransparent() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }

    func resetBackgroundImage() {
        setBackgroundImage(nil, for: .default)
        shadowImage = nil
    }
}
