//
//  UIView+gradientBackground.swift
//  Swift3Project
//
//  Created by Yilei He on 8/11/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

private let layerIdentifier = "GradientBackgroundLayer"
extension UIView {

    @discardableResult
    func setGradientBackgroundColor(
        colors: [UIColor],
        locations: [CGFloat]? = nil,
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) -> LinearGradientView {
            let gradientView = LinearGradientView(frame: bounds, colors: colors, start: startPoint, end: endPoint, locations: locations)
            insertSubview(gradientView, at: 0)
            gradientView.autoresizingMask = .fixedAllMarginFlexibleSize
            return gradientView
    }
}
