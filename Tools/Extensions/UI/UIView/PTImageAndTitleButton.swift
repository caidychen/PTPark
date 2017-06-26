//
//  PTImageAndTitleButton.swift
//  PTPark
//
//  Created by Chunlin on 2017/5/6.
//
//

import UIKit

class PTImageAndTitleButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Center image
        var center = self.imageView?.center
        center?.x = self.frame.size.width/2
        center?.y = (self.imageView?.frame.size.height)! / 2
        self.imageView?.center = center!
        
        // Center image
        var newFrame = self.titleLabel?.frame
        newFrame?.origin.x = 0
        newFrame?.origin.y = (self.imageView?.frame.size.height)! + 5
        newFrame?.size.width = self.frame.size.width
        
        self.titleLabel?.frame = newFrame!
        self.titleLabel?.textAlignment = .center
    }
}
