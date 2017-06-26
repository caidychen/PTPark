//
//  PTPhotoBrowserCell.swift
//  QRCodeReader
//
//  Created by CHEN KAIDI on 24/4/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

typealias DidSingleTap = () -> ()

let PTPhotoBrowserCellID = "PTPhotoBrowserCellID"
public class PTPhotoBrowserCell: UICollectionViewCell {
    
    var image:UIImage? {
        didSet {
            configureForNewImage()
        }
    }
    
    var didSingleTap:DidSingleTap?
    
    fileprivate var _scrollView: UIScrollView?
    var _imageView: UIImageView?
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.addSubview(imageView)
        
        scrollView.delegate = self
        contentView.addSubview(scrollView)
        setupGestureRecognizer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    func configureForNewImage() {
        
        imageView.sizeToFit()
        imageView.alpha = 0.0
        setZoomScale()
        scrollViewDidZoom(scrollView)
        imageView.origin = .zero
        UIView.animate(withDuration: 0.5) {
            self.imageView.alpha = 1.0
        }
    }
    
    public func singleTapAction(recognizer: UITapGestureRecognizer) {
        if let a = self.didSingleTap{
            print(NSStringFromCGRect(imageView.frame))
            a()
        }
    }
    
    
    @objc fileprivate func doubleTapAction(recognizer: UITapGestureRecognizer) {
        
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            scrollView.isScrollEnabled = false
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
            scrollView.isScrollEnabled = true
        }
    }
    
    private func setupGestureRecognizer() {
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(recognizer:)))
        singleTap.numberOfTapsRequired = 1

        self.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.cancelsTouchesInView = false
        self.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
    }
    
    private func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
    }
    
    // MARK: - Getters
    var scrollView:UIScrollView{
        if _scrollView == nil {
            _scrollView = UIScrollView(frame: self.bounds)
            _scrollView?.showsVerticalScrollIndicator = false
            _scrollView?.showsHorizontalScrollIndicator = false
        }
        return _scrollView!
    }
    
    var imageView:UIImageView{
        if _imageView == nil {
            _imageView = UIImageView(frame: self.scrollView.bounds)
            _imageView?.contentMode = .scaleAspectFit
        }
        return _imageView!
    }
    
    
}

// MARK: UIScrollViewDelegate Methods
extension PTPhotoBrowserCell: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        if verticalPadding >= 0 {
            // Center the image on screen
            scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        } else {
            // Limit the image panning to the screen bounds
            scrollView.contentSize = imageViewSize
        }
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if (scrollView.zoomScale == scrollView.minimumZoomScale) {
            scrollView.isScrollEnabled = false
        }else{
            scrollView.isScrollEnabled = true
        }
    }
    
}



