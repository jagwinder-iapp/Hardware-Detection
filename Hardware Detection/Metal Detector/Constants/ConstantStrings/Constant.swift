//
//  Constant.swift
//  Metal Detector
//
//  Created by iapp on 23/02/24.
//

import Foundation
import UIKit


enum Constants {
    
    static let success = "Success."
    static let error = "Error"
    static let alert = "Alert"
    static let emailPlaceholder = "email@gmail.com"
    static let bottomSheetView = "BottomSheetView"
    static let homeScreenTopTitle = """
                                     METAL
                                     DETECTOR
                                     """
    static let detectorSearch = """
        DETECTOR
BEING SEARCHED
"""
    static let metalDetector = "Metal detector"
    static let electromagneticdetector = "Electromagnetic Detector"
    static let cameraDetector = "Camera Detector"
    static let studDetector = "Stud Detector"
    static let mailSecurity = "Mail security"
    
    static let review = "Write a review"
    static let feedbackSupport = "Feedback and support"
    static let billingInformation = "Billing information"
    static let faq = "FAQ"
    static let restorePurchase = "Restore Purchase"
    
    
    static let smokeAlarms = "Smoke alarms"
    static let airFilters = "Air filters"
    static let books = "Books"
    static let deskPlants = "Desk plants"
    static let peluches = "Peluches"
    static let dvdCases = "DVD cases"
    static let lavaLamps = "Lava lamps"
    static let powerSockets  = "Power sockets"
    static let wardrobes  = "Wardrobes"
    static let TVs = "TVs"
    static let flowerPots = "Flowerpots"
    static let locksOnTheDoor  = "Locks on the door "
    static let roofs = "Roofs"
    static let doorbell = "Doorbell"
    
        
    
}



enum HomeScreenImageName {
    static let metalDetectorIcon = "HomeMetalDetectorIcon"
    static let electromagneticdetectorIcon = "ElectroMagneticIcon"
    static let cameraDetectorIcon = "CameraDetectorIcon"
    static let studDetectorIcon = "StudDetectorIcon"
    static let mailSecurityIcon = "MailSecurityIcon"
    static let defaultHomeBackgroundImageOfCell = "HomeListBackgroundImage"
    static let firstCellImageOfHomeScreen = "FirstImageOfHomeScreen"
}

enum SettingScreenImage {
    static let reviewIcon = "ReviewIcon"
    static let feedbackIcon = "support_agent"
    static let biilingIcon = "Icon_Billing"
    static let faqIcon = "Icon_FAQ"
    static let restorePuschaseIcon = "Icon_restorPurchase"
}


enum InfraRedImages {
    static let indoorsSmokeSensor = "Indoors _ Smoke sensor"
    static let indoorsAC = "Indoors _ AC"
    static let IndoorsBooks = "Indoors _ Books"
    static let IndoorsDeskplant = "Indoors _ Desk plant"
    static let IndoorsPeluches = "Indoors _ Peluches"
    static let IndoorsDVD = "Indoors _ DVD"
    static let IndoorsLamp = "Indoors _ Lamp"
    static let IndoorsSocket = "Indoors _ Socket"
    static let IndoorsTv = "Indoors _ Tv"
    static let IndoorsWardrobes = "Indoors _ Wardrobes"
    static let OutdoorPot = "Outdoor _ Pot"
    static let OutdoorLocks = "Outdoor _ Locks"
    static let OutdoorRoof = "Outdoor _ Roof"
    static let OutdoorDoorbell = "Outdoor _ Door bell"
    
}


enum Identifiers {
    static let homeTableViewCell = "HomeTableViewCell"
    static let wifiListTableViewCell = "WifiListTableViewCell"
    static let emailSheetTableViewCell = "EmailSheetTableViewCell"
    static let allDetailsDescriptionTableViewCell = "AllDetailsDescriptionTableViewCell"
    static let settingsTableViewCell = "SettingsTableViewCell"
    static let instructionListTableViewCell = "InstructionListTableViewCell"
    static let outdoorsListTableViewCell = "OutdoorsListTableViewCell"
}

enum AnimationKey {
    static let rotateKeyPath = "transform.rotation.z"
    static let forKey = "rotationAnimationass"
}


enum InfoString {
    static let metalTitle = "How to make the best use of your metal detector"
    static let electorMagneticTitle = "How to make the best use of your Electromagnetic Detector"
    static let cameraDetectorTitle = "How to make the best use of your Camera Detector"
    static let wifiDetectorTitle = "How to make the best use of Wi-Fi  Detector"
    static let studDetectorTitle = "How to make the best use of your Stud detector"
    static let mailDetectorTitle = "How to make the best use of your mail detector"
    static let metalDescription = "You can further improve the detection accuracy by first determining the position of the magnetometer sensor inside of your phone(it's usually located at the top). To do this, take a small metal object for example.a scrowland slowly move along the back surface of vour phone, continuously monitoring the absolute value indicator of the magnetic field.The sensor is located at the position with the maximum indicator value. Be careful not to touch and scratch the phone with the screw."
}


struct ErrorMessage {
    static let error_Internet_connectMessage    = "Please check your Internet connection and try again."
}
