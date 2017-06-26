//
//  UIViewController+Login.swift
//  PTPark
//
//  Created by soso on 2017/5/18.
//
//

import UIKit

extension UIViewController {
    
    func runUntilLogined(_ blcok: @escaping () -> ()) {
        if PTUserManager.share.isLogin() {
            DispatchQueue.main.async(execute: blcok)
            return
        }
        let loginVC = PTLoginViewController(nibName: "PTLoginViewController", bundle: nil)
        loginVC.loginSuccess = {
            DispatchQueue.main.async(execute: blcok)
        }
        let nav = PTBaseNavigationController(rootViewController: loginVC)
        self.present(nav, animated: true) {
            
        }
    }
    
}
