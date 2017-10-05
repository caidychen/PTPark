//
//  UITableView+lastIndex.swift
//  Swift3Project
//
//  Created by Yilei He on 7/11/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension UITableView {
    var lastIndexPath: IndexPath {
        let lastSection = self.numberOfSections - 1
        let lastRow = self.numberOfRows(inSection: lastSection) - 1
        return IndexPath(row: lastRow, section: lastSection)
    }

    override func scrollToBottom(animated: Bool) {
        self.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
    }
}
