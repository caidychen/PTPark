//
//  PTRollLabel.swift
//  PTPark
//
//  Created by Chunlin on 2017/6/8.
//
//

import UIKit

extension UIView {
    func pushTransition(_ duration:CFTimeInterval = 0.3) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromTop
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionPush)
    }
}

class PTRollLabel: UILabel {
    
    var titles: [String] = [String]() {
        didSet{
            if titles.count > 0 {
                startRoll()
            }
        }
    }
    
    var tapIndex:((String,Int)->())? = nil
    
    fileprivate var timer: Timer!
    fileprivate var index = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        config()
    }
    
    fileprivate func config() {
        isUserInteractionEnabled = true
    }
    
    @objc fileprivate func changeText(timer: Timer) {
        index += 1
        if index >= titles.count {
            index = 0
        }
        self.text = titles[index]
        
        if titles.count > 1 {
            self.pushTransition(0.3)
        }
    }
    
    @objc fileprivate func tapLabel(gr: UITapGestureRecognizer) {
        tapIndex?(titles[index],index)
    }
    
    func startRoll() {
        self.text = titles[0]
        
        if timer != nil && timer.isValid {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(changeText(timer:)), userInfo: nil, repeats: true)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gr:)))
        addGestureRecognizer(tapGR)
    }
    
    func stopRoll() {
        if timer.isValid {
            timer.invalidate()
        }
    }
}
