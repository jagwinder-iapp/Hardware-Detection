//
//  Enumerations.swift
//  Metal Detector
//
//  Created by iapp on 23/02/24.
//

import UIKit

//MARK: - Home Listing Data
enum HomeScreenData : Int {
    case metalDetector
    case electroMagneticDetector
    case cameraDetector
    case studDetector
    case mailSecurity
    
    func setTitle() -> String {
        switch self {
        case .metalDetector:
            return Constants.metalDetector
        case .electroMagneticDetector:
            return Constants.electromagneticdetector
        case .cameraDetector:
            return Constants.cameraDetector
        case .studDetector:
            return Constants.studDetector
        case .mailSecurity:
            return Constants.mailSecurity
        }
    }
    
    func setImage() -> UIImage {
        switch self {
        case .metalDetector:
            return UIImage(named: HomeScreenImageName.metalDetectorIcon)!
        case .electroMagneticDetector:
            return UIImage(named: HomeScreenImageName.electromagneticdetectorIcon)!
        case .cameraDetector:
            return UIImage(named: HomeScreenImageName.cameraDetectorIcon)!
        case .studDetector:
            return UIImage(named: HomeScreenImageName.studDetectorIcon)!
        case .mailSecurity:
            return UIImage(named: HomeScreenImageName.mailSecurityIcon)!
        }
    }
    
    func setBackgroundImage() -> UIImage {
        switch self {
        case .metalDetector:
            return UIImage(named: HomeScreenImageName.firstCellImageOfHomeScreen)!
        default:
            
            return UIImage(named: HomeScreenImageName.defaultHomeBackgroundImageOfCell)!
        }
    }
}

//MARK: - Setting Screen Data
enum SettingData: Int {
    case review
    case feedbackAndSupport
    case billingInformation
    case faq
    case restorePurchase
    
    func setTitle() -> String {
        switch self {
        case .review:
            return Constants.review
        case .feedbackAndSupport:
            return Constants.feedbackSupport
        case .billingInformation:
            return Constants.billingInformation
        case .faq:
            return Constants.faq
        case .restorePurchase:
            return Constants.restorePurchase
        }
    }
    
    func setImage() -> UIImage {
        switch self {
        case .review:
            return UIImage(named: SettingScreenImage.reviewIcon)!
        case .feedbackAndSupport:
            return UIImage(named: SettingScreenImage.feedbackIcon)!
        case .billingInformation:
            return UIImage(named: SettingScreenImage.biilingIcon)!
        case .faq:
            return UIImage(named: SettingScreenImage.faqIcon)!
        case .restorePurchase:
            return UIImage(named: SettingScreenImage.restorePuschaseIcon)!
        }
    }
}

//MARK: - Mail Security Screen Options
enum ScanningOption {
    case startScanning
    case scanningResult
    case none
}

enum InfoType {
    case info
    case wifi
    case camera
    case elecroMagnetic
    case mail
    case wifiText
    case stud
}

enum CameraDetectorPhase {
    case initialState
    case scanningState
    case result
}


