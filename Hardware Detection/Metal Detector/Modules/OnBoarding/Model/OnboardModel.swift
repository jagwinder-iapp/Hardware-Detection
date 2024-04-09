//
//  OnboardModel.swift
//  Metal Detector
//
//  Created by iApp on 04/03/24.
//

import Foundation

let onboardArr:[OnboardModel] = [.first,.second,.third]


struct OnbaordData{
    
    var imageName:String
    var title:String
    var subTitle:String
}


enum OnboardModel{
    
    case first
    case second
    case third
    
    var data: OnbaordData{
        switch self {
        case .first:
            return OnbaordData(imageName: "onboard1", title: "STAY PREPARED AT ALL TIMES.", subTitle: "In an era where safety and security are paramount concerns, having the right tools readily available is crucial.")
        case .second:
            return OnbaordData(imageName: "onboard2", title: "THE ALL-IN-ONE DETECTION APP", subTitle: "With a comprehensive array of detection tools conveniently packed into one application, Metal Detector ensures you're always prepared.")
        case .third:
            return OnbaordData(imageName: "onboard3", title: "THIS APP IS ALL YOU NEED TO STAY SAFE!", subTitle: "Discover all tools: Metal Detector, Electromagnetic Detector, Camera Detector, Stud Detector, and Mail Security.")
        }
    }
}
