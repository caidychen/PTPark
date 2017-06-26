//
//  PTBaseTabBarController.swift
//  PTPark
//
//  Created by soso on 2017/4/20.
//
//

import UIKit

class PTBaseTabBarController: UITabBarController {
    
    override var shouldAutorotate: Bool {
        return selectedViewController?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        // 商城
        addChildViewController(childController: PTStoreViewController(), title: "商城", imageName: "icon_24_house")
        // 成长
        addChildViewController(childController: PTGrowViewController(), title: "成长", imageName: "icon_24_discover")
        // 购物车
        addChildViewController(childController: PTCartViewController(), title: "购物车", imageName: "icon_24_cart")
        // 我
        addChildViewController(childController: PTUserCenterViewController(), title: "我", imageName: "icon_24_me")
        
        setUp()
    }
    
    func addChildViewController(childController: UIViewController, title: String, imageName: String) {
        let normalImageName = imageName+"_nor"
        childController.title = title
        childController.tabBarItem.title = title
        childController.tabBarItem.image = UIImage(named: normalImageName)
        
        let selectImageName = imageName + "_sel"
        let selectImage = UIImage(named: selectImageName)?.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = selectImage
        
        childController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3.0)
        let textAttrs = [NSForegroundColorAttributeName: UIColor(hexValue: 0x959595), NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
        childController.tabBarItem.setTitleTextAttributes(textAttrs, for: UIControlState())
        
        let selectAttrs = [NSForegroundColorAttributeName: UIColor(hexValue: 0x8B49F6), NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
        childController.tabBarItem.setTitleTextAttributes(selectAttrs, for: .selected)
        
        self.addChildViewController(PTBaseNavigationController(rootViewController: childController))
    }
    
    func setUp() {
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -100), for: .default)
//        self.tabBar.layer.shadowOpacity = 5
//        self.tabBar.layer.shadowRadius = 5
//        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 10)
//        self.tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
    }
    
    func reset() {
        self.viewControllers?.forEach({ (vc) in
            if let navc = vc as? UINavigationController {
                navc.popToRootViewController(animated: false)
                return
            }
        })
    }
}
