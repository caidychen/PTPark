//
//  PTBaseSectionItem.swift
//  PTPark
//
//  Created by soso on 2017/4/26.
//
//

import Foundation

protocol PTBaseSectionItemType {
    
    var header: PTBaseCellItemType? { get set }
    
    var rows: [PTBaseCellItemType]? { get set }
    
    var footer: PTBaseCellItemType? { get set }
    
}

class PTBaseSectionItem<RowType>: PTBaseCellItem where RowType : PTBaseCellItemType {
    
    var header: RowType?
    
    var rows: [RowType]
    
    var footer: RowType?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        rows = [RowType]()
        super.init()
    }
    
}
