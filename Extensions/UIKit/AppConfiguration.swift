//
//  AppConfiguration.swift
//
//
//  Created by Yilei He on 14/04/2016.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

// MARK: - UIApplication -
extension UIApplication {

    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    static var appBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }

    static var versionBuildInformation: String {
        return "Version \(appVersion) Build \(appBuild)"
    }

    /**
     If the "CFBundleDisplayName" in the info.plist is not nil, return the value of it. Otherwise return the value of "CFBundleName"
     
     - returns: The name of the App
     */
    static var appDisplayName: String? {
        if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return bundleDisplayName
        } else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundleName
        }
        return nil
    }

    static var appDelegate: UIApplicationDelegate {
        return UIApplication.shared.delegate!
    }

    static var rootViewController: UIViewController {
        return appDelegate.window!!.rootViewController!
    }

}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UIApplication {
    var appIcon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
            // First will be smallest for the device class, last will be the largest for device class
            let lastIcon = iconFiles.last,
            let icon = UIImage(named: lastIcon) else {
                return nil
        }
        return icon
    }
}

// MARK: - Set the theme of the app -
struct AppTheming {

    static func setStatusBarBackgroundColor(_ color: UIColor) {
        UIApplication.shared.statusBarView?.backgroundColor = color
    }

    static func setWindowTintColor(_ color: UIColor) {
        UIApplication.shared.delegate?.window??.tintColor = color
    }

    static func setNavigationBar(barStyle style: UIBarStyle = .default, barTintColor: UIColor? = nil, tintColor: UIColor? = nil, titleTextForegroundColor: UIColor? = nil) {
        UINavigationBar.appearance().barStyle = style
        if let color = barTintColor {
            UINavigationBar.appearance().barTintColor = color
        }
        if let color = tintColor {
            UINavigationBar.appearance().tintColor = color
        }
        if let color = titleTextForegroundColor {
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: color]
        }
    }

    static func setTabBar(barStyle style: UIBarStyle = .default, barTintColor: UIColor? = nil, tintColor: UIColor? = nil, titleTextUnselectedColor: UIColor? = nil, titleTextSelectedColor: UIColor? = nil) {
        UITabBar.appearance().barStyle = style
        if let color = barTintColor {
            UITabBar.appearance().barTintColor = color
        }
        if let color = tintColor {
            UITabBar.appearance().tintColor = color
        }
        if let color = titleTextUnselectedColor {
            UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: color], for: .normal)
        }
        if let color = titleTextSelectedColor {
            UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: color], for: .selected)
        }

    }

    static func setSearchBar(barStyle style: UIBarStyle = .default, searchBarStyle: UISearchBarStyle = .default, barTintColor: UIColor? = nil, tintColor: UIColor? = nil, barButtonTextForegroundColor: UIColor? = nil) {
        UISearchBar.appearance().barStyle = style
        UISearchBar.appearance().searchBarStyle = searchBarStyle
        if let color = barTintColor {
            UISearchBar.appearance().barTintColor = color
        }

        if let color = tintColor {
            UISearchBar.appearance().tintColor = color
        }
        if let color = barButtonTextForegroundColor {
            UISearchBar.appearance().setScopeBarButtonTitleTextAttributes([NSForegroundColorAttributeName: color], for: .normal)
        }
    }
}

private let versionKey = "Version"
// MARK: - run once for current app version -
/**
 Do the task only once for current App Version
 
 - parameter task: A closure of type ()->()
 */
func executeOnceForCurrentAppVersion(_ task:() -> Void) {
    let userDefaults = UserDefaults.standard
    if userDefaults.object(forKey: versionKey) == nil {
        task()
        userDefaults.set(UIApplication.appVersion, forKey: versionKey)
        return
    }

    if (userDefaults.object(forKey: versionKey) as! String) != UIApplication.appVersion {
        task()
        userDefaults.set(UIApplication.appVersion, forKey: versionKey)
        return
    }
}

func executeOnceForKey(key:String, task:() -> Void) {
    let userDefaults = UserDefaults.standard
    if userDefaults.object(forKey: key) == nil {
        task()
        userDefaults.set(UIApplication.appVersion, forKey: key)
        return
    }
}

func setAppExirationDate(expirationDate: Date, alertTitle: String?, alertMessage: String?) {
    let currentDate = Date()
    if currentDate.compare(expirationDate) == .orderedDescending {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
            (_: UIAlertAction) in
            exit(0)
        }
        alertController.addAction(action)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.tintColor = UIApplication.shared.delegate!.window!!.tintColor
        alertWindow.windowLevel = UIApplication.shared.windows.last!.windowLevel + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
