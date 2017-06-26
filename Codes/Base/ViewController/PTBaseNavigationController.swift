//
//  PTBaseNavigationController.swift
//  PTPark
//
//  Created by soso on 2017/4/13.
//
//

import UIKit
import PKHUD

class PTBaseNavigationController: UINavigationController {
    
    var willDisappearBlock: ((_ animated: Bool) -> ())?
    
    override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = UIColor(hexValue: 0x646464)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(hexValue: 0x313131), NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        willDisappearBlock?(animated)
    }
    
}
