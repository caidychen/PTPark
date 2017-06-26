//
//  PTPhotoBrowserView.swift
//  QRCodeReader
//
//  Created by CHEN KAIDI on 21/4/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Kingfisher


class PTPhotoBrowserView: UIView {

    private var _collectionView:UICollectionView?
    var photoArray:Array<String> = Array(){
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    class func show(photoArray:[String], pageIndex:Int, imageView:UIView, image:UIImage?){
        let photoBrowser = PTPhotoBrowserView(frame: UIScreen.main.bounds)
        photoBrowser.photoArray = photoArray
        photoBrowser.setPageIndex(index: pageIndex)
        let originalFrame = UIApplication.shared.keyWindow?.convert(imageView.bounds, from: imageView)
        UIApplication.shared.keyWindow?.addSubview(photoBrowser)
        photoBrowser.showAnimatedFromImage(image: image, frame:originalFrame!)
    }
    
    override init (frame:CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.addSubview(collectionView)
        
        
        let panGesture = PanDirectionGestureRecognizer(direction: PanDirection.vertical, target: self, action: #selector(wasDragged(_:)))
        self.addGestureRecognizer(panGesture)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func showAnimatedFromImage(image:UIImage?, frame:CGRect){
        self.collectionView.alpha = 0.0
        let imageView = UIImageView(frame: frame)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
        if let image = image {
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseOut, animations: {
                let imageViewSize = CGSize(width: self.width, height: self.width/image.size.width*image.size.height)
                imageView.frame = CGRect(x: 0, y: (self.height-imageViewSize.height)/2, width: imageViewSize.width, height: imageViewSize.height)
                
            }) { (finished) in
                imageView.removeFromSuperview()
                self.collectionView.alpha = 1.0
            }
        }
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        let window = UIApplication.shared.keyWindow?.rootViewController?.view
        UIView.animate(withDuration: 0.35) {
            self.backgroundColor = UIColor.black.withAlphaComponent(1.0)
            window?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
        
        
        
        
    }

    
    func setPageIndex(index:Int){
        if index >= self.photoArray.count{
            return
        }
        let indexPath = NSIndexPath(row: index, section: 0)
        self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .centeredHorizontally, animated: false)
    }
    
    @objc private func wasDragged(_ gesture: PanDirectionGestureRecognizer) {
        
        let image = collectionView
        
        let translation = gesture.translation(in: self)
        image.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY + translation.y)
        
        let yFromCenter = image.center.y - self.bounds.midY
        
        let alpha = 1 - abs(yFromCenter / self.bounds.midY)
        self.backgroundColor = backgroundColor?.withAlphaComponent(alpha)
        
        if gesture.state == UIGestureRecognizerState.ended {
            
            let swipeBuffer: CGFloat = 150
            var animateImageAway = false
            
            let velocity = gesture.velocity(in: gesture.view)
            
            print("\(gesture.velocity(in: gesture.view))")
            
            if yFromCenter > -swipeBuffer && yFromCenter < swipeBuffer  && fabsf(Float(velocity.y)) < 500 {
                // reset everything
                UIView.animate(withDuration: 0.25, animations: {
                    self.backgroundColor = self.backgroundColor?.withAlphaComponent(1.0)
                    image.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
                })
            } else if yFromCenter < -swipeBuffer {

                animateImageAway = true
            } else {

                animateImageAway = true
            }
            
            if animateImageAway {
                
                let window = UIApplication.shared.keyWindow?.rootViewController?.view
                UIView.animate(withDuration: 0.5) {
                    window?.transform = CGAffineTransform.identity
                }

                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.6, options: .curveEaseOut, animations:{
                    self.backgroundColor = UIColor.blue.withAlphaComponent(0.0)
                    if velocity.y < 0 {
                        image.center = CGPoint(x: self.bounds.midX, y: -image.bounds.size.height/2)
                    }else{
                        image.center = CGPoint(x: self.bounds.midX, y: image.bounds.size.height + image.bounds.size.height/2)
                    }
                    
                }, completion: { (complete) in
                   self.removeFromSuperview()
                })
            }
        }
    }

    
    
    var collectionView:UICollectionView{
        if _collectionView == nil {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let spacing:CGFloat = 0
            layout.itemSize = CGSize(width: self.frame.size.width, height:self.frame.size.height)
            layout.minimumInteritemSpacing = spacing
            layout.minimumLineSpacing = spacing
            _collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
            _collectionView?.backgroundColor = .clear
            _collectionView?.delegate = self
            _collectionView?.dataSource = self
            _collectionView?.register(PTPhotoBrowserCell.self, forCellWithReuseIdentifier: PTPhotoBrowserCellID)
            _collectionView?.isPagingEnabled = true
        }
        return _collectionView!
    }
}


extension PTPhotoBrowserView:UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoArray.count
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? PTPhotoBrowserCell {
            cell.configureForNewImage()
        }
    }
}

extension PTPhotoBrowserView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PTPhotoBrowserCellID, for: indexPath) as! PTPhotoBrowserCell
//        cell.image = UIImage(named: photoArray[indexPath.row])
        cell.imageView.kf.setImage(with: URL(string: photoArray[indexPath.row]), placeholder: nil, options: nil, progressBlock: nil) { (image, error, cahceTupe, url) in
            cell.image = image
        }
        cell.configureForNewImage()
        cell.didSingleTap = {
            let window = UIApplication.shared.keyWindow?.rootViewController?.view
            UIView.animate(withDuration: 0.5) {
                window?.transform = CGAffineTransform.identity
            }
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
                self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.alpha = 0.0
            }, completion: { (finished) in
                self.removeFromSuperview()
            })
        }
        return cell
    }
}



