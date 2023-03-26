//
//  UIApplication + Extension.swift
//  Employder
//
//  Created by Serov Dmitry on 07.10.22.
//

import UIKit

extension UIApplication {

    class func getTopViewController(
        base: UIViewController? = UIApplication.shared.mainKeyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
