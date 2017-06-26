//
//  UICollectionViewExtension.swift
//  PTPark
//
//  Created by Chunlin on 2017/4/27.
//
//

import UIKit

extension UICollectionView {
    //MARK: - Cell
    func registerNibWithCell<T: UICollectionViewCell>(_ cell: T.Type) {
        register(UINib(nibName: String(describing: cell), bundle: nil), forCellWithReuseIdentifier: String(describing: cell))
    }
    
    func registerClassWithCell<T: UICollectionViewCell>(_ cell: T.Type) {
        register(cell, forCellWithReuseIdentifier: String(describing: cell))
    }
    
    func dequeueCell<T: UICollectionViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cell), for: indexPath) as! T
    }
}
