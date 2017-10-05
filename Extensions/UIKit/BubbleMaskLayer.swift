//
//  BubbleMaskLayer.swift
//  OMNIMeetingPOC
//
//  Created by Yilei He on 11/08/2016.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

enum AnchorPosition {
    case top(x:CGFloat)
    case left(y:CGFloat)
    case right(y:CGFloat)
    case bottom(x:CGFloat)
}

extension CALayer {
    class func bubbleMaskLayer(frameSize size: CGSize, anchorSize: CGSize, anchorPosition: AnchorPosition, cornerRadius: CGFloat) -> CALayer {
        let shapeLayer = CAShapeLayer()
        let path: UIBezierPath

        switch anchorPosition {
        case .top(let x):
            //verify point
            var x = max(0, x)
            x = min(size.width, x)

            //initialize rectangle
            let rect = CGRect(x: 0, y: anchorSize.height, width: size.width, height: size.height - anchorSize.height)
            path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)

            //draw triangle
            let actualWidth = (anchorSize.width / anchorSize.height) * (anchorSize.height + cornerRadius)
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: min(size.width, x + actualWidth), y: anchorSize.height + cornerRadius))
            path.addLine(to: CGPoint(x: max(0, x - actualWidth), y: anchorSize.height + cornerRadius))
            path.addLine(to: CGPoint(x: x, y: 0))

        case .left(let y):
            //verify point
            var y = max(0, y)
            y = min(size.height, y)

            //initialize rectangle
            let rect = CGRect(x: anchorSize.width, y: 0, width: size.width - anchorSize.width, height: size.height)
            path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)

            //draw triangle
            let actualHeight = (anchorSize.height / anchorSize.width) * (anchorSize.width + cornerRadius)
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: anchorSize.width + cornerRadius, y: max(0, y - actualHeight / 2 )))
            path.addLine(to: CGPoint(x: anchorSize.width + cornerRadius, y: min(y + actualHeight / 2, size.height)))
            path.addLine(to: CGPoint(x: 0, y: y))

        case .right(let y):
            //verify point
            var y = max(0, y)
            y = min(size.height, y)

            //initialize rectangle
            let rect = CGRect(x: 0, y: 0, width: size.width - anchorSize.width, height: size.height)
            path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)

            //draw triangle
            let actualHeight = (anchorSize.height / anchorSize.width) * (anchorSize.width + cornerRadius)
            path.move(to: CGPoint(x: size.width, y: y))
            path.addLine(to: CGPoint(x: size.width - anchorSize.width - cornerRadius, y: min(y + actualHeight / 2, size.height)))
            path.addLine(to: CGPoint(x: size.width - anchorSize.width - cornerRadius, y: max(y - actualHeight / 2, 0)))
            path.addLine(to: CGPoint(x: size.width, y: y))

        case .bottom(let x):
            //verify point
            var x = max(0, x)
            x = min(size.width, x)

            //initialize rectangle
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height - anchorSize.height)
            path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)

            //draw triangle
            let actualWidth = (anchorSize.width / anchorSize.height) * (anchorSize.height + cornerRadius)
            path.move(to: CGPoint(x: x, y: size.height))
            path.addLine(to: CGPoint(x: max(0, x - actualWidth / 2), y: size.height - anchorSize.height - cornerRadius))
            path.addLine(to: CGPoint(x: min(size.width, x + actualWidth / 2), y: size.height - anchorSize.height - cornerRadius))
            path.addLine(to: CGPoint(x: x, y: size.height))

        }

        shapeLayer.path = path.cgPath
        return shapeLayer
    }
}
