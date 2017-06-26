//
//  PTTextSegmentControl.swift
//  PTPark
//
//  Created by CHEN KAIDI on 7/6/2017.
//
//

import UIKit

typealias PTTextSegmentControlCallback = (Int) -> ()

struct PTTextSegmentItem{
    var text:String!
    var font:UIFont = UIFont.systemFont(ofSize: 14)
    var baseColor:UIColor = UIColor.gray
    var highlightColor:UIColor!
    var width:CGFloat!
}

enum PTTrackerStyle {
    case dot
    case line
}

//  Must configure these imageNames for new project
let DropdownButtonArrowDownImageName = "btn_arrow_down_g"
let DropdownButtonArrowUpImageName = "btn_arrow_up_g"
let DropdownTableviewCellAccessoryImageName = "check_circular_sel"

class PTTextSegmentControl: UIView {

    var segmentControlCallback:PTTextSegmentControlCallback?
    var segmentItems:[PTTextSegmentItem]?{
        didSet{ self.configureUI() }
    }
    var activeIndex = 0 {
        didSet{
            if buttonArray.count > 0 && activeIndex < buttonArray.count{
                self.updateIndex(index:activeIndex)
            }
        }
    }

    var animateTracker = false
    
    var trackerStyle:PTTrackerStyle = .dot{
        didSet{
            switch trackerStyle {
            case .dot:
                dot.isHidden = false
                line.isHidden = true
                break
            case .line:
                dot.isHidden = true
                line.isHidden = false
                break
            }
        }
    }
    
    var blurredBackground = true{
        didSet{
            blurView.isHidden = !blurredBackground
        }
    }
    
    fileprivate var _blurView:UIVisualEffectView?
    fileprivate var segmentControlHeight:CGFloat = 0
    fileprivate var dropdownTableHeight:CGFloat = 0
    fileprivate var segmentControlOriginalTop:CGFloat = 0
    fileprivate var segmentControlNewTop:CGFloat = 0
    fileprivate var _scrollView:UIScrollView?
    fileprivate var buttonArray:[UIButton] = []
    fileprivate var _dot:UIView?
    fileprivate var _line:UIView?
    fileprivate var _arrowButton:UIButton?
    fileprivate var showingDropdown = false
    fileprivate var _dropdownTitleLabel:UILabel?
    fileprivate var _tableView:UITableView?
    
    override init (frame:CGRect){
        super.init(frame: frame)
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.insertSubview(blurView, at: 0)
        blurView.frame = self.bounds
        self.segmentControlHeight = frame.size.height
        self.addSubview(scrollView)
        self.addSubview(dropdownTitleLabel)
        let bottomLine = UIView(frame: CGRect(x: 0, y: self.height - 0.5, width: self.width, height: 0.5))
        bottomLine.backgroundColor = .zircon
        self.addSubview(bottomLine)
        self.addSubview(arrowButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDropdownMode(title:String ,heightForTableView:CGFloat, segmentControlTop:CGFloat){
        self.dropdownTitleLabel.text = title
        dropdownTableHeight = heightForTableView
        
        segmentControlNewTop = segmentControlTop
        self.arrowButton.isHidden = false
        self.scrollView.width = self.width - self.arrowButton.width
        self.tableView.frame = CGRect(x: 0, y: self.segmentControlHeight, width: self.width, height: heightForTableView)
    }
    
    fileprivate func configureUI(){
        self.scrollView.subviews.forEach({$0.removeFromSuperview()})
        self.buttonArray.removeAll()
        guard let segmentItems = self.segmentItems else {return}
        var previousX:CGFloat = 0
        var index = 0
        for item in segmentItems{
            let textButton = UIButton(frame: CGRect(x: previousX, y: 0, width: item.width, height: self.height))
            textButton.setTitle(item.text, for: .normal)
            textButton.titleLabel?.font = item.font
            textButton.titleLabel?.adjustsFontSizeToFitWidth = true
            textButton.setTitleColor(item.baseColor, for: .normal)
            textButton.tag = index
            textButton.addTarget(self, action: #selector(toggleIndex(sender:)), for: .touchUpInside)
            previousX = textButton.right
            self.scrollView.contentSize = CGSize(width: textButton.right, height: self.height)
            self.scrollView.addSubview(textButton)
            self.buttonArray.append(textButton)
            index = index + 1
        }
        
        self.scrollView.addSubview(dot)
        self.scrollView.addSubview(line)
    }
    
    @objc fileprivate func toggleIndex(sender:UIButton){
        self.activeIndex = sender.tag
    }
    
    @objc fileprivate func updateIndex(index:Int){
        for button in self.buttonArray{
            if let item = self.segmentItems?[button.tag]{
                if button.tag == index {
                    button.setTitleColor(item.highlightColor, for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: item.font.pointSize, weight: UIFontWeightBold)
                    
                    var animateDuration = 0.0
                    if animateTracker {
                        animateDuration = 0.35
                    }
                    UIView.animate(withDuration: animateDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.6, options: .curveEaseOut, animations: {
                        self.dot.center = CGPoint(x: button.centerX, y: self.segmentControlHeight/2 + item.font.lineHeight/2 + 7)
                        self.line.width = item.text.width(withConstrainedWidth: self.width, font: item.font)
                        self.line.center = self.dot.center
                    }, completion: { (finished) in
                        
                    })
                    
                    line.backgroundColor = item.highlightColor
                    
                    if let a = self.segmentControlCallback{
                        a(button.tag)
                    }
                    button.popup(0.35)
                    if scrollView.contentSize.width > scrollView.width{
                        var contentOffsetX = dot.centerX - scrollView.width/2
                        if contentOffsetX <= 0 {contentOffsetX = 0}
                        else if contentOffsetX >= scrollView.contentSize.width - scrollView.width{
                            contentOffsetX = scrollView.contentSize.width - scrollView.width
                        }
                        scrollView.setContentOffset(CGPoint(x:contentOffsetX, y:0), animated: true)
                    }
                    
                }else{
                    button.setTitleColor(item.baseColor, for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: item.font.pointSize, weight: UIFontWeightRegular)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    @objc fileprivate func toggleArrowButton(){
        if !showingDropdown{
            self.showDropdownTableview()
        }else{
            self.hideDropdownTableview()
        }
    }
    
    fileprivate func showDropdownTableview(){
        segmentControlOriginalTop = self.top
        self.arrowButton.setImage(UIImage(named:DropdownButtonArrowUpImageName), for: .normal)
        showingDropdown = true
        self.addSubview(tableView)
        
        let height = self.dropdownTableHeight
        tableView.height = 0
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.66, options: .curveEaseOut, animations: {
            self.scrollView.center = CGPoint(x: self.scrollView.centerX + self.width, y: self.scrollView.centerY)
            self.dropdownTitleLabel.left = 15
            self.tableView.height = height
            self.height = self.tableView.bottom
            self.blurView.height = self.height
            self.top = self.segmentControlNewTop
        }) { (finished) in
            
        }
    }

    fileprivate func hideDropdownTableview(){
         self.arrowButton.setImage(UIImage(named:DropdownButtonArrowDownImageName), for: .normal)
        showingDropdown = false
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.66, options: .curveEaseIn, animations: {
            self.scrollView.center = CGPoint(x: self.scrollView.width/2, y: self.scrollView.centerY)
            self.dropdownTitleLabel.left = -(self.width-30)
            self.tableView.height = 0
            self.height = self.segmentControlHeight
            self.blurView.height = self.segmentControlHeight
            self.top = self.segmentControlOriginalTop
        }) { (finished) in
            self.tableView.removeFromSuperview()
           
        }
        
    }
    
    fileprivate var blurView:UIVisualEffectView{
        if _blurView == nil {
            let blurEffect: UIBlurEffect = UIBlurEffect(style: .extraLight)
            _blurView = UIVisualEffectView(effect: blurEffect)
        }
        return _blurView!
    }
    
    fileprivate var scrollView:UIScrollView{
        if _scrollView == nil {
            _scrollView = UIScrollView(frame: self.bounds)
            _scrollView?.showsVerticalScrollIndicator = false
            _scrollView?.showsHorizontalScrollIndicator = false
        }
        return _scrollView!
    }
    
    fileprivate var dot:UIView{
        if _dot == nil {
            _dot = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 3))
            _dot?.backgroundColor = .theme
            _dot?.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4.0)
        }
        return _dot!
    }
    
    fileprivate var line:UIView{
        if _line == nil{
            _line = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 2))
            _line?.isHidden = true
        }
        return _line!
    }
    
    fileprivate var arrowButton:UIButton{
        if _arrowButton == nil {
            _arrowButton = UIButton(frame: CGRect(x: self.width - 34, y: 0, width: 34, height: self.height))
            _arrowButton?.setImage(UIImage(named:DropdownButtonArrowDownImageName), for: .normal)
            _arrowButton?.isHidden = true
            _arrowButton?.addTarget(self, action: #selector(toggleArrowButton), for: .touchUpInside)
        }
        return _arrowButton!
    }
    
    fileprivate var dropdownTitleLabel:UILabel{
        if _dropdownTitleLabel == nil {
            _dropdownTitleLabel = UILabel(frame: CGRect(x: -(self.width-30), y: 0, width: self.width-30, height: self.height))
            _dropdownTitleLabel?.font = UIFont.systemFont(ofSize: 14)
            _dropdownTitleLabel?.textColor = .textMist
        }
        return _dropdownTitleLabel!
    }
    
    fileprivate var tableView:UITableView{
        if _tableView == nil {
            _tableView = UITableView(frame: .zero, style: .plain)
            _tableView?.delegate = self
            _tableView?.dataSource = self
            _tableView?.backgroundColor = .clear
            _tableView?.registerClassWithCell(PTTextSegmentControlDropdownCell.self)
        }
        return _tableView!
    }
    
}

extension PTTextSegmentControl:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let segmentItems = self.segmentItems{
            return segmentItems.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(PTTextSegmentControlDropdownCell.self)
        if let segmentItems = self.segmentItems{
            cell.productLabel.text = segmentItems[indexPath.row].text
            if self.activeIndex == indexPath.row{
                cell.productLabel.textColor = .theme
                cell.productLabel.font = UIFont.boldSystemFont(ofSize: cell.productLabel.font.pointSize)
                cell.tickIcon.isHidden = false
            }else{
                cell.productLabel.textColor = .textDust
                cell.productLabel.font = UIFont.systemFont(ofSize: cell.productLabel.font.pointSize)
                cell.tickIcon.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let deadlineTime = DispatchTime.now() + 0.35
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.activeIndex = indexPath.row
        }
        self.hideDropdownTableview()
    }
}

class PTTextSegmentControlDropdownCell:UITableViewCell{
    
    fileprivate var _productLabel:UILabel?
    fileprivate var _tickIcon:UIImageView?
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init (style:style, reuseIdentifier:reuseIdentifier)
        self.backgroundColor = .clear
        self.addSubview(productLabel)
        self.addSubview(tickIcon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.productLabel.frame = CGRect(x: 15, y: 0, width: self.width - tickIcon.width - 30, height: self.height)
        self.tickIcon.frame = CGRect(x: productLabel.right, y: self.height/2 - tickIcon.height/2, width: tickIcon.width, height: tickIcon.height)
    }
    
    var productLabel:UILabel{
        if _productLabel == nil {
            _productLabel = UILabel()
            _productLabel?.textColor = .textDust
        }
        return _productLabel!
    }

    var tickIcon:UIImageView{
        if _tickIcon == nil {
            _tickIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            _tickIcon?.image = UIImage(named: DropdownTableviewCellAccessoryImageName)
            _tickIcon?.isHidden = true
        }
        return _tickIcon!
    }
}


