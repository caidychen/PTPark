//
//  PTBaseCellItem.swift
//  PTPark
//
//  Created by soso on 2017/4/26.
//
//

import Foundation
import ObjectMapper

extension SOBaseItem {
    @discardableResult
    func parseValue(map: Map, for key: String) -> Any? {
        guard let v = map.JSON[key] else {
            return nil
        }
        self.setValue(v, forKey: key)
        return v
    }
}


protocol PTBaseCellItemType {
    var contentInsets: UIEdgeInsets { get set}
    var gap: CGSize  { get set}
    
    var isTopLineHidden: Bool  { get set}
    var topLineInsets: UIEdgeInsets  { get set}
    
    var isBottomLineHidden: Bool  { get set}
    var bottomLineInsets: UIEdgeInsets  { get set}
    
    var height: CGFloat { get set }
    
    var accessoryType: UITableViewCellAccessoryType { get set }
}

public class PTBaseCellItem: SOBaseItem, PTBaseCellItemType {
    
    var contentInsets: UIEdgeInsets = .zero
    var gap: CGSize = .zero
    
    var isTopLineHidden: Bool = true
    var topLineInsets: UIEdgeInsets = .zero
    
    var isBottomLineHidden: Bool = true
    var bottomLineInsets: UIEdgeInsets = .zero
    
    var height: CGFloat = 0
    
    var accessoryType: UITableViewCellAccessoryType = .none
    
    public override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let keys = SOPropertyKeyList(self.classForCoder)
        keys?.forEach({ (key) in
            self.setValue(aDecoder.value(forKey: key), forKey: key)
        })
    }
    
}
