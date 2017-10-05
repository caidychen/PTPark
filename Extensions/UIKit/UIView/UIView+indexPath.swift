//
//  UIView.swift
//
//  Created by HeYilei on 16/02/2016.
//  Copyright © 2016 lionhylra. All rights reserved.
//

import UIKit

extension UIView {
    /**
     To get the indexPath of a view in the table view. The receiver's center point must in one of the table view cells.
     
     - parameter tableView: The table view must be in the receiver's super view hierarchy
     
     - returns: The indexPath of the cell in which the receiver is positioned
     */
    func indexPathInTableView(_ tableView: UITableView) -> IndexPath? {
        let centerPoint = CGPoint(x: (bounds.maxX - bounds.minX) / 2, y: (bounds.maxY - bounds.minY) / 2)
        let point = self.convert(centerPoint, to:tableView)
        return tableView.indexPathForRow(at: point)
    }

    /**
     To get the indexPath of a view in the collection view. The receiver's center point must in one of the collection view cells.
     
     - parameter collectionView: The collection view must be in the receiver's super view hierarchy
     
     - returns: The indexPath of the cell in which the receiver is positioned
     */
    func indexPathInCollectionView(_ collectionView: UICollectionView) -> IndexPath? {
        let centerPoint = CGPoint(x: (bounds.maxX - bounds.minX) / 2, y: (bounds.maxY - bounds.minY) / 2)
        let point = self.convert(centerPoint, to: collectionView)
        return collectionView.indexPathForItem(at: point)
    }

}
