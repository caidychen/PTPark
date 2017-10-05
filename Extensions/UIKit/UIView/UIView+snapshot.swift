//
//  UIView+snapshot.swift
//  Swift3Project
//
//  Created by Yilei He on 23/09/2016.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension UIView {

    /// Take screenshot of current view.
    ///
    /// - parameter rect: The area need to take screen shot. If nil, then take the view's bounds. nil by default.
    /// - parameter afterScreenUpdates: if true, when you click a button to take screenshot, in the screenshot, the button's status is clicked. if false, the button's appearance before being tapped is taken into screenshot
    ///
    /// - returns: The image of the screenshot
    func snapshot(rect: CGRect? = nil, afterScreenUpdates: Bool = false) -> UIImage? {
        /* define graphic context */
        UIGraphicsBeginImageContextWithOptions(rect?.size ?? bounds.size, true, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        /* move the context's origin */
        UIGraphicsGetCurrentContext()?.translateBy(x: -(rect?.origin.x ?? 0), y: -(rect?.origin.y ?? 0))

        /* render image */
        drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    var screenshot: UIImage? {
        return self.snapshot()
    }
}

extension UIScrollView {

    var screenshotOfVisibleContent: UIImage? {
        var croppingRect = self.bounds
        croppingRect.origin = self.contentOffset
        return self.snapshot(rect: croppingRect)
    }

    /// Take screenshot of the scroll view's content view
    ///
    /// - parameter rect: The area need to take screen shot. If nil, then take the whole conten view(contentSize). nil by default.
    /// - parameter afterScreenUpdates: if true, when you click a button to take screenshot, in the screenshot, the button's status is clicked. if false, the button's appearance before being tapped is taken into screenshot
    ///
    /// - returns: The image of the screenshot
    func snapshotContentView(rect: CGRect? = nil) -> UIImage? {

        /* resize the view to render whole content */
        let originalSize = bounds.size
        bounds.size = contentSize
        bounds.size.height += contentInset.bottom
        bounds.size.height += contentInset.top
        bounds.size.width += contentInset.left
        bounds.size.width += contentInset.right
        defer { bounds.size = originalSize }

        /* define graphic context */
        UIGraphicsBeginImageContextWithOptions(rect?.size ?? bounds.size, true, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        /* move the context's origin */
        UIGraphicsGetCurrentContext()?.translateBy(x: -(rect?.origin.x ?? 0), y: -(rect?.origin.y ?? 0))

        /* render image */
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
