//
//  AppCordinator.swift
//  Metal Detector
//
//  Created by iapp on 23/02/24.
//

import Foundation
import UIKit

//MARK: - App StoryBoards
enum AppStoryBoards {
    case OnBoarding
    case Home
    case Camera
    case Setting
    case MailSecurity
}


class AppCordinator: Cordinator<AppStoryBoards> {
    
    //MARK: - Properties
    private var window: UIWindow?
    
    //MARK: - Init
    
    required init(window: UIWindow? = nil) {
        self.window = window
    }
    
    //MARK: - Overrides
    @discardableResult
    override func start() -> UIViewController? {
        super.start()
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return navigationController
    }
    
    override func navigate(to stepper: AppStoryBoards) -> NavigationEvent {
        switch stepper {
        case .OnBoarding:
            if let onBoardAppNavigation = OnBoardingCordinator().start() {
                return .push(onBoardAppNavigation)
            }
            return .none
        case .Home:
            if let homeAppNavigation = HomeAppCordinator().start() {
                return.push(homeAppNavigation)
            }
            return .none
            
        case .Camera:
            if let cameraDetectorAppNavigation = CameraDetectorCordinator().start() {
                return .push(cameraDetectorAppNavigation)
            }
            return .none
        case .Setting:
            if let cameraDetectorAppNavigation = SettingsCordinator().start() {
                return .push(cameraDetectorAppNavigation)
            }
            
            if let info = SettingsCordinator().start() {
                return .present(info, .fullScreen)
            }
            
            return .none
        case .MailSecurity:
            if let mailSecurityAppNavigation = MailSecurityCordinator().start() {
                return .push(mailSecurityAppNavigation)
            }
            
            if let allMailDetailAppNavigation = MailSecurityCordinator().start() {
                return .present(allMailDetailAppNavigation, .fullScreen)
            }
            return .none
        }
    }
}



