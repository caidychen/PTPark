//
//  CocoaClassExtension.swift
//
//
//  Created by HeYilei on 28/02/2016.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    func removeBorders() {
        func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
            let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            color.setFill()
            UIRectFill(rect)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        }
        setBackgroundImage(imageWithColor(UIColor.clear, size: self.bounds.size), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(UIColor.clear, size: self.bounds.size), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(UIColor.clear, size: CGSize(width: 1, height: 1)), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }

    /*
    var segments: [UIView] {
        return subviews.filter{ type(of: $0).description() == "UISegment" }.sorted{ $0.frame.origin.x < $1.frame.origin.x }
    }
    */
}
