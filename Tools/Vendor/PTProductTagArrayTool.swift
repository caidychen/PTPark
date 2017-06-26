//
//  PTProductTagArrayTool.swift
//  PTPark
//
//  Created by CHEN KAIDI on 26/4/2017.
//
//

import UIKit

class PTProductTagArrayTool: NSObject {

    class func getTagsView(textArray:Array<String>, spacing:CGFloat , padding:CGFloat, color:UIColor, fontSize:Int) -> UIView{
        let view = UIView()
        var previousLabel = UILabel()
        var index = 0
        var margin:CGFloat = 0
        for text in textArray{
            let textLabel = UILabel()
            textLabel.text = text
            textLabel.textColor = color
            textLabel.textAlignment = .center
            textLabel.layer.borderWidth = 1
            textLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
            textLabel.layer.borderColor = color.cgColor
            if index != 0 {
                margin = spacing
            }
            textLabel.frame = CGRect(x: previousLabel.right + margin, y: 0, width: text.width(withConstrainedWidth: Screenwidth, font: textLabel.font) + padding * 2, height: textLabel.font.lineHeight + padding * 2)
            view.addSubview(textLabel)
            previousLabel = textLabel
            view.frame = CGRect(x: 0, y: 0, width: textLabel.right, height: textLabel.height)
            index = index + 1
        }
        return view
    }

}

