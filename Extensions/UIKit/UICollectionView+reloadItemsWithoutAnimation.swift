//
//  UICollectionView+reloadItemsWithoutAnimation.swift
//  Swift3Project
//
//  Created by Yilei on 15/2/17.
//  Copyright © 2017 lionhylra.com. All rights reserved.
//

import UIKit

extension UICollectionView {
    func reloadItems(at indexPaths: [IndexPath], animated: Bool) {
        if !animated {
            UIView.performWithoutAnimation {
                reloadItems(at: indexPaths)
            }
        } else {
            reloadItems(at: indexPaths)
        }
    }
}
