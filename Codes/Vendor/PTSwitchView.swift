//
//  PTSwitchView.swift
//  PTSwitchView
//
//  Created by KangYang on 2017/4/19.
//  Copyright © 2017年 Putao. All rights reserved.
//

import UIKit

class PTSwitchView: UIControl {
    
    var isOn: Bool = false
    
    var textColor: UIColor = .white
    var dotColor: UIColor = .white
    
    var bgColor_on: UIColor = UIColor(red:0.25, green:0.75, blue:0.19, alpha:1)
    var sliderColor_on: UIColor = UIColor(red:0.39, green:0.80, blue:0.33, alpha:1)
    var bgColor_off: UIColor = UIColor(red:0.97, green:0.98, blue:0.98, alpha:1)
    var sliderColor_off: UIColor = UIColor(red:0.97, green:0.98, blue:0.98, alpha:1)
    
    var dotSize: CGSize = CGSize(width: 36, height: 36)
    var innerSize: Float = 5
    
    private let switchView = UIView()
    private let sliderView = UIView()
    private let dotView = UIView()
    private let textLabel = UILabel()
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        self.configureFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.addSubview(switchView)
        switchView.addSubview(sliderView)
        sliderView.addSubview(textLabel)
        sliderView.addSubview(dotView)
        
        textLabel.font = UIFont.systemFont(ofSize: 12)
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.text = "左滑解除绑定"
        
        switchView.backgroundColor = bgColor_off
        sliderView.backgroundColor = sliderColor_off
        dotView.backgroundColor = dotColor
        
        dotView.layer.shadowColor = UIColor.gray.cgColor
        dotView.layer.shadowOffset = CGSize(width: 2, height: 2)
        dotView.layer.shadowRadius = 4
        dotView.layer.shadowOpacity = 0.3
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(panGestureAction(sender:)))
        switchView.addGestureRecognizer(panGesture)
    }
    
    private func configureFrame() {
        switchView.frame = self.bounds
        sliderView.frame = self.bounds.insetBy(dx: CGFloat(innerSize), dy: CGFloat(innerSize))
        dotView.frame = CGRect(x: 0, y: 0, width: dotSize.width, height: dotSize.width)
        textLabel.frame = CGRect(x: (sliderView.bounds.width - 200) / 2,
                                 y: (sliderView.bounds.height - 18) / 2,
                                 width: 200, height: 18)
        
        switchView.layer.cornerRadius = switchView.bounds.height / 2
        sliderView.layer.cornerRadius = sliderView.bounds.height / 2
        dotView.layer.cornerRadius = sliderView.bounds.height / 2
    }
    
    func setOn(_ on: Bool, animated: Bool = true) {
        
        let didValueChanged = isOn != on
        isOn = on
        if didValueChanged {
            sendActions(for: .valueChanged)
        }
        
        let duration = animated ? 0.25 : 0
        if on {
            UIView.animate(withDuration: duration, animations: {
                self.dotView.frame = CGRect(x: self.sliderView.bounds.width - self.sliderView.bounds.height,
                                            y: 0,
                                            width: self.dotSize.width,
                                            height: self.dotSize.height)
                self.switchView.backgroundColor = self.bgColor_on
                self.sliderView.backgroundColor = self.sliderColor_on
            })
        } else {
            UIView.animate(withDuration: duration, animations: {
                self.dotView.frame = CGRect(x: 0, y: 0,
                                            width: self.dotSize.width,
                                            height: self.dotSize.height)
                self.switchView.backgroundColor = self.bgColor_off
                self.sliderView.backgroundColor = self.sliderColor_off
            })
        }
    }
    
    @objc private func panGestureAction(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: switchView)
        let semiHeight = CGFloat(floorf(Float(self.frame.height / 2.0)))
        let semiWidtht = CGFloat(floorf(Float(self.frame.width / 2.0)))
        
        if sender.state == .changed {
            
            if dotView.frame.origin.x + translation.x >= CGFloat(innerSize) &&
                dotView.frame.midX + translation.x + CGFloat(innerSize) <= self.bounds.width - semiHeight {
                
                dotView.frame = CGRect(x: dotView.frame.origin.x + translation.x,
                                       y: dotView.frame.origin.y,
                                       width: dotSize.width,
                                       height: dotSize.height)
            }
            
        } else if sender.state == .ended || sender.state == .cancelled {
            
            if isOn == false && dotView.frame.midX > semiWidtht {
                setOn(true)
            } else if isOn == false && dotView.frame.midX <= semiWidtht {
                setOn(false)
            } else if isOn == true && dotView.frame.midX < semiWidtht {
                setOn(false)
            } else if isOn == true && dotView.frame.midX >= semiWidtht {
                setOn(true)
            }
            
        }
        
        sender.setTranslation(CGPoint.zero, in: switchView)
    }
}
