//
//  UIScrollView+scrollToBottom.swift
//  Swift3Project
//
//  Created by Yilei He on 7/11/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
}
