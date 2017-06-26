//
//  UIImageView+Loading.swift
//  PTPark
//
//  Created by soso on 2017/6/1.
//
//

import UIKit
import SnapKit
import Kingfisher

extension UIImageView {
    
    fileprivate static let PTLoadFailedImage = UIImage(named: "img_pic_loading_fail")
    fileprivate static let PTLoadingImages = [UIImage(named: "ani_pic_loading_01"),
                                              UIImage(named: "ani_pic_loading_02"),
                                              UIImage(named: "ani_pic_loading_03"),
                                              UIImage(named: "ani_pic_loading_04"),
                                              UIImage(named: "ani_pic_loading_05"),
                                              UIImage(named: "ani_pic_loading_06"),
                                              UIImage(named: "ani_pic_loading_07"),
                                              UIImage(named: "ani_pic_loading_08"),
                                              UIImage(named: "ani_pic_loading_09"),
                                              UIImage(named: "ani_pic_loading_10"),
                                              UIImage(named: "ani_pic_loading_11"),
                                              UIImage(named: "ani_pic_loading_12"),
                                              UIImage(named: "ani_pic_loading_13"),
                                              UIImage(named: "ani_pic_loading_14"),
                                              UIImage(named: "ani_pic_loading_15"),
                                              UIImage(named: "ani_pic_loading_16"),
                                              UIImage(named: "ani_pic_loading_17"),
                                              UIImage(named: "ani_pic_loading_18"),
                                              UIImage(named: "ani_pic_loading_19"),
                                              UIImage(named: "ani_pic_loading_20")]
    
    fileprivate static let PTLoadingImageViewTag: Int = 0x99999
    fileprivate var animationImageView: UIImageView? {
        get {
            return self.viewWithTag(UIImageView.PTLoadingImageViewTag) as? UIImageView
        }
        set {
            if newValue == animationImageView {
                return
            }
            if let current = animationImageView {
                current.removeFromSuperview()
            }
            guard let imageView = newValue else {
                return
            }
            
            imageView.tag = UIImageView.PTLoadingImageViewTag
            
            self.addSubview(imageView)
            
            imageView.snp.makeConstraints { (maker) in
                maker.center.equalToSuperview()
            }
            
        }
    }
    
    func cancelLoad() {
        if let ani = animationImageView {
            ani.stopAnimating()
            ani.image = nil
        }
        self.kf.cancelDownloadTask()
    }
    
    func loadImage(url: URL?, showLoading: Bool = true, placeHolder: UIImage? = nil, failed: UIImage? = PTLoadFailedImage) {
        if self.image == nil {
            if animationImageView == nil {
                animationImageView = UIImageView(frame: 32.0.square)
            }
            if animationImageView!.isAnimating {
                animationImageView?.stopAnimating()
            }
            animationImageView!.image = failed
            if animationImageView?.animationImages == nil {
                animationImageView!.animationImages = UIImageView.PTLoadingImages as? [UIImage]
            }
            if !animationImageView!.isAnimating {
                animationImageView?.startAnimating()
            }
        }
        
        self.kf.setImage(with: url, placeholder: showLoading ? nil : placeHolder, options: [.transition(.fade(0.2))], progressBlock: nil) { [weak self] (img, error, type, url) in
            if let imageView = self?.animationImageView {
                if imageView.isAnimating {
                    imageView.stopAnimating()
                }
            }
            guard let image = img else {
                self?.animationImageView?.image = failed
                return
            }
            self?.image = image
            self?.animationImageView?.image = nil
            self?.animationImageView?.removeFromSuperview()
        }
        
    }
    
}
