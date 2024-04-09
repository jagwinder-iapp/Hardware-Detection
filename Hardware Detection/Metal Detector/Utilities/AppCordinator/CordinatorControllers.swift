//
//  CordinatorControllers.swift
//  Metal Detector
//
//  Created by iapp on 23/02/24.
//

import Foundation
import UIKit



final class OnBoardingCordinator: Cordinator<AppStoryBoards> {
    
    //MARK: - Override Methods
    override func navigate(to stepper: AppStoryBoards) -> NavigationEvent {
        switch stepper{
        default:
            return .none
        }
    }
    
  @discardableResult
    override func start() -> UIViewController? {
        super.start()
        let controller =  WelcomeViewController.control()
        return controller
    }
}

final class HomeAppCordinator: Cordinator<AppStoryBoards> {
    
    override func navigate(to stepper: AppStoryBoards) -> NavigationEvent {
        switch stepper {
        default:
            return .none
        }
    }
    
    @discardableResult
    override func start() -> UIViewController? {
        super.start()
        let controller = HomeViewController.control()
        return controller
    }
    
}

final class CameraDetectorCordinator: Cordinator<AppStoryBoards> {
    
    override func navigate(to stepper: AppStoryBoards) -> NavigationEvent {
        switch stepper {
        default:
            return .none
        }
    }
    
    @discardableResult
    override func start() -> UIViewController? {
        super.start()
        let controller = CameraDetectorViewController.control()
        return controller
    }
    
}

final class SettingsCordinator: Cordinator<AppStoryBoards> {
    
    override func navigate(to stepper: AppStoryBoards) -> NavigationEvent {
        switch stepper {
        default:
            return .none
        }
    }
    
    @discardableResult
    override func start() -> UIViewController? {
        super.start()
        let controller = SettingViewController.control()
        return controller
    }
}

final class MailSecurityCordinator: Cordinator<AppStoryBoards> {
    
    override func navigate(to stepper: AppStoryBoards) -> NavigationEvent {
        switch stepper {
        default:
            return .none
        }
    }
    
    @discardableResult
    override func start() -> UIViewController? {
        super.start()
        let controller = MailSecurityViewController.control()
        return controller
    }
}

//final class AllDetailOfEmailCordinator: Cordinator<AppStoryBoards> {
//    
//    override func navigate(to stepper: AppStoryBoards) -> NavigationEvent {
//        switch stepper {
//        default:
//            return .none
//        }
//    }
//    
//    @discardableResult
//    override func start() -> UIViewController? {
//        super.start()
//        let controller = AllDetailViewController.control()
//        return controller
//    }
//}
