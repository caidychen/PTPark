//
//  PTPickerView.swift
//  PTLatitude
//
//  Created by 王炜程 on 16/6/8.
//  Copyright © 2016年 PT. All rights reserved.
//

import UIKit

class PTDatePickerView: UIView {
    
    fileprivate let shadowView = UIView()
    fileprivate let cancel = UIButton(type: .custom)
    fileprivate let ok = UIButton(type: .custom)
    fileprivate var cancelAction : ((UIButton) -> Void)?
    fileprivate var okAction : ((UIButton, Date) -> Void)?
    
    var datePicker = UIDatePicker()
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        
        shadowView.frame = CGRect(x: 0, y: 0, width: Screenwidth, height: Screenheight)
        shadowView.addSubview(self)
        
        let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(hideDatePicker))
        shadowView.addGestureRecognizer(cancelGesture)
        
        backgroundColor = UIColor(hexValue: 0xf6f6f7)
        
        cancel.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        cancel.setTitle("取消", for: UIControlState())
        cancel.setTitleColor(UIColor(hexValue: 0x157efb), for: UIControlState())
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancel.addTarget(self, action: #selector(PTDatePickerView.actionHandle(_:)), for: .touchUpInside)
        addSubview(cancel)
        
        ok.frame = CGRect(x: Screenwidth - 80, y: 0, width: 80, height: 44)
        ok.setTitle("确定", for: UIControlState())
        ok.setTitleColor(UIColor(hexValue: 0x157efb), for: UIControlState())
        ok.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        ok.addTarget(self, action: #selector(PTDatePickerView.actionHandle(_:)), for: .touchUpInside)
        addSubview(ok)
        
        datePicker.frame = CGRect(x: 0, y: 44, width: Screenwidth, height: 216)
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        
//        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        // 公历
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var dateComponents = DateComponents()
        dateComponents.day = 1
        dateComponents.month = 1
        dateComponents.year = 2013

        datePicker.date = calendar.date(from: dateComponents)!
        
//        let minDate = Date(timeIntervalSince1970: 883584000)  // 2000/1/1 0:00:00 时间戳：946656000
//        datePicker.minimumDate = minDate
        
//        let maxDate = Date(timeIntervalSince1970: 2145887999)  // 2036/12/31 0:00:00 时间戳：2114294400
//        datePicker.maximumDate = maxDate
        
        addSubview(datePicker)
        
    }
    
    
    
    // MARK: -
    func addCancelAction(_ cancelAction: ((UIButton)-> Void)?, okAction: ((UIButton, Date)->Void)?) {
        self.cancelAction = cancelAction
        self.okAction = okAction
    }
    
    func showDatePicker() {
        // 判断是否frame为0
        if frame == CGRect.zero {
            frame = CGRect(x: 0, y: Screenheight, width: Screenwidth, height: 260)
        }
        UIApplication.shared.keyWindow?.addSubview(shadowView)
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.frame = CGRect(x: 0, y: Screenheight-216-44, width: Screenwidth, height: 216+44)
            self.shadowView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            }) { (finished) in
                
        }
    }
    
    func hideDatePicker() {
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { 
            self.frame = CGRect(x: 0, y: Screenheight, width: Screenwidth, height: 216+44)
            self.shadowView.backgroundColor = UIColor(white: 0, alpha: 0.0)
            }) { (finished) in
                self.shadowView.removeFromSuperview()
        }
    }
    
    // MARK: - private func
    @objc fileprivate func actionHandle(_ sender : UIButton) {
        if sender == cancel && self.cancelAction != nil {
            self.cancelAction!(cancel)
        }else if sender == ok && self.okAction != nil {
            self.okAction!(ok,datePicker.date)
        }
        hideDatePicker()
    }
    
    // MARK: -
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("PTDatePickerView was destoryed")
    }
}


class PTPickerView: UIView {
    
    fileprivate let shadowView = UIView()
    fileprivate let cancel = UIButton(type: .custom)
    fileprivate let ok = UIButton(type: .custom)
    fileprivate var cancelAction : ((UIButton) -> Void)?
    fileprivate var okAction : ((UIButton, _ row: Int) -> Void)?
    
    var pickerView = UIPickerView()
    
    var delegate : UIPickerViewDelegate {
        get {
            return pickerView.delegate!
        }
        
        set(delegate) {
            pickerView.delegate = delegate
        }
    }
    
    var dataSource : UIPickerViewDataSource {
        get {
            return (pickerView.dataSource)!
        }
        
        set(dataSource) {
            pickerView.dataSource = dataSource
        }
    }
    
    override var tag: Int {
        get {
            return pickerView.tag
        }
        
        set(tag) {
            pickerView.tag = tag
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        shadowView.frame = CGRect(x: 0, y: 0, width: Screenwidth, height: Screenheight)
        shadowView.addSubview(self)
        
        let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(hidePicker))
        shadowView.addGestureRecognizer(cancelGesture)
        
        backgroundColor = UIColor(hexValue: 0xf6f6f7)
        
        cancel.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        cancel.setTitle("取消", for: UIControlState())
        cancel.setTitleColor(UIColor(hexValue: 0x157efb), for: UIControlState())
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancel.addTarget(self, action: #selector(PTPickerView.actionHandle(_:)), for: .touchUpInside)
        addSubview(cancel)
        
        ok.frame = CGRect(x: Screenwidth - 80, y: 0, width: 80, height: 44)
        ok.setTitle("确定", for: UIControlState())
        ok.setTitleColor(UIColor(hexValue: 0x157efb), for: UIControlState())
        ok.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        ok.addTarget(self, action: #selector(PTPickerView.actionHandle(_:)), for: .touchUpInside)
        addSubview(ok)
        
        pickerView.frame = CGRect(x: 0, y: 44, width: Screenwidth, height: 216)
        pickerView.backgroundColor = UIColor.white
        addSubview(pickerView)
    }
    
    // MARK: -
    func addCancelAction(_ cancelAction : ((UIButton)-> Void)?, okAction: ((UIButton,_ row: Int)->Void)?) {        
        self.cancelAction = cancelAction
        self.okAction = okAction
    }
    
    func showPicker() {
        // 判断是否frame为0
        if frame == CGRect.zero {
            frame = CGRect(x: 0, y: Screenheight, width: Screenwidth, height: 260)
        }
        UIApplication.shared.keyWindow?.addSubview(shadowView)
        self.top = Screenheight
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.frame = CGRect(x: 0, y: Screenheight-216-44, width: Screenwidth, height: 216+44)
            self.shadowView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        }) { (finished) in
            
        }
    }
    
    func hidePicker() {
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.frame = CGRect(x: 0, y: Screenheight, width: Screenwidth, height: 216+44)
            self.shadowView.backgroundColor = UIColor(white: 0, alpha: 0.0)
        }) { (finished) in
            self.shadowView.removeFromSuperview()
        }
    }
    
    func defaultRow(_ row: Int) {
        pickerView.selectRow(row, inComponent: 0, animated: false)
    }
    
    // MARK: - private func
    @objc fileprivate func actionHandle(_ sender : UIButton) {
        if sender == cancel && self.cancelAction != nil{
            self.cancelAction!(cancel)
        }else if sender == ok && self.okAction != nil {
            self.okAction!(ok,pickerView.selectedRow(inComponent: 0))
        }
        hidePicker()
    }
    
    // MARK: -
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("PTPickerView was destoryed")
    }
    
}
