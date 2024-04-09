//
//  AppStoryBoard.swift
//  Metal Detector
//
//  Created by iapp on 23/02/24.
//

import UIKit

enum AppAllStoryBoards: String {
    case OnBoarding, Home, MetalDetector, Setting, Camera, MailSecurity, Magnetic, Purchase
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue , bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T{
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initialViewController() -> UIViewController?{
        return instance.instantiateInitialViewController()
    }
}

extension UIStoryboard {
    class func storyboard(_ storyboard: AppAllStoryBoards) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil)
    }
}

extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func initiantiate(fromAppStoryboard appStoryboard: AppAllStoryBoards) -> Self{
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
