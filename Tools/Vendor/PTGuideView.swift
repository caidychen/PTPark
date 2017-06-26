//
//  PTGuideView.swift
//  PTPark
//
//  Created by soso on 2017/5/24.
//
//

import UIKit

struct PTGuideValues {
    static let key = "com.putao.ptpark.guide"
    static let cell = "com.putao.ptpark.cell.identifier"
}

class PTGuideProgressView: UIView {
    
    var total: Int = 1
    var progress: CGFloat = 0 {
        didSet {
            blockView.left = self.width * progress
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(blockView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blockView.size = CGSize(width: self.width / CGFloat(self.total), height: self.height)
        blockView.left = self.width * progress
    }
    
    fileprivate lazy var blockView: UIView = {
        let view = UIView(frame: CGSize(width: self.width / CGFloat(self.total), height: self.height).bounds)
        view.backgroundColor = UIColor(hexValue: 0x8633f6)
        return view
    }()
    
}

class PTGuideCollectionViewCell : UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
    
    fileprivate lazy var imageView: UIImageView = {
        let i = UIImageView()
        return i
    }()
    
}


class PTGuideView: UIView {
    
    var imageNames: [String]? {
        didSet {
            self.progress.total = imageNames?.count ?? 1
            self.collectionView.reloadData()
        }
    }
    
    var dismiss: (() -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        self.addSubview(progress)
        self.addSubview(enter)
        enter.alpha = 0
        
        enter.bind({ [weak self] _ in
            if let version = AppVersion() {
                UserDefaults.standard.setValue(version, forKey: PTGuideValues.key)
                UserDefaults.standard.synchronize()
            }
            UIView.animate(withDuration: 0.2, animations: { 
                self?.alpha = 0
            }, completion: { (finished) in
                self?.dismiss?()
                self?.removeFromSuperview()
            })
        }, for: .touchUpInside)
        .end()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
        progress.centerX = self.bounds.centerX
        progress.centerY = self.bounds.height - 78.0
        enter.centerX = self.bounds.centerX
        enter.centerY = progress.centerY
    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionInset = .zero
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = true
        cv.isPagingEnabled = true
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.registerClassWithCell(PTGuideCollectionViewCell.self)
        return cv
    }()
    
    fileprivate lazy var progress: PTGuideProgressView = {
        let view = PTGuideProgressView(frame: CGSize(width: 125, height: 4).bounds)
        view.backgroundColor = UIColor(hexValue: 0xebebeb)
        return view
    }()
    
    fileprivate lazy var enter: UIButton = {
        let button = UIButton(frame: 52.0.square)
        button.setImage(UIImage(named: "btn_52_p"), for: UIControlState.normal)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 1
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.masksToBounds = false
        return button
    }()
    
}

extension PTGuideView {
    
    class func show(_ inView: UIView, _ force: Bool = false, _ dismiss: (() -> ())?) -> Bool {
        
        let scale = UIScreen.main.scale
        let screenSize = (Int(scale * UIScreen.main.bounds.size.width), Int(scale * UIScreen.main.bounds.size.height))
        switch screenSize {
        case (640, 960):
            return show(["1-4", "2-4", "3-4"], inView, force, dismiss)
        case (640, 1136):
            return show(["1-5", "2-5", "3-5"], inView, force, dismiss)
        default:
            return show(["1-6", "2-6", "3-6"], inView, force, dismiss)
        }
        
    }
    
    class func show(_ imageNames: [String]?, _ inView: UIView, _ force: Bool = false, _ dismiss: (() -> ())?) -> Bool {
        guard let names = imageNames else {
            return false
        }
        if !force {
            let version = AppVersion()
            let didVersion = UserDefaults.standard.value(forKey: PTGuideValues.key) as? String
            if version == didVersion {
                return false
            }
        }
        
        inView.endEditing(true)
        
        let guideView = PTGuideView(frame: UIScreen.main.bounds)
        guideView.imageNames = names
        guideView.dismiss = dismiss
        
        inView.addSubview(guideView)
        
        return true
    }
    
}

extension PTGuideView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.size
    }
}

extension PTGuideView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset
        let x = min(scrollView.contentSize.width - scrollView.width, max(0, offset.x))
        offset.x = x
        scrollView.contentOffset = offset
        self.progress.progress = offset.x / scrollView.contentSize.width
        
        let cut = 1.5 * scrollView.width
        if offset.x < (scrollView.contentSize.width - cut) {
            self.enter.isHidden = true
            return
        }
        let less = offset.x - cut
        let p = less / (scrollView.width / 2.0)
        
        self.enter.isHidden = false
        self.progress.alpha = 1.0 - p
        self.enter.alpha = p
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let names = self.imageNames else {
            return 0
        }
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(PTGuideCollectionViewCell.self, for: indexPath)
        if let imageNamed = self.imageNames?.safeObject(at: indexPath.item) as? String {
            cell.imageView.image = UIImage(named: imageNamed)
        }
        return cell
    }
    
}
