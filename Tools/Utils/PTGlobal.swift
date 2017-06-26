//
//  PTGlobal.swift
//  PTPark
//
//  Created by soso on 2017/6/8.
//
//

import Foundation
import UIKit

//Screen Size
let Screenwidth = UIScreen.main.bounds.size.width
let Screenheight = UIScreen.main.bounds.size.height
let HEIGHT_STATUS = CGFloat(20.0)
let HEIGHT_NAV = CGFloat(44.0)
let HEIGHT_BAR = CGFloat(49.0)

public func AppVersion() -> String? {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}
