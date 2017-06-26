//
//  URL+ImageURL.swift
//  PTPark
//
//  Created by soso on 2017/5/25.
//
//

import Foundation

extension URL {
    
    fileprivate static let separator = "_"
    func imageSize(_ width: Int, _ height: Int) -> URL {
        if width <= 0 || height <= 0 {
            return self
        }
        var last_comp = self.deletingPathExtension().lastPathComponent
        var elements = last_comp.components(separatedBy: URL.separator)
        if elements.count < 2 {
            return self
        }
        elements.removeLast(1)
        elements.append("\(width)x\(height)")
        last_comp = elements.joined(separator: URL.separator)
        
        var url = self.deletingLastPathComponent()
        url = url.appendingPathComponent(last_comp)
        url = url.appendingPathExtension(self.pathExtension)
        return url
    }
    
}
