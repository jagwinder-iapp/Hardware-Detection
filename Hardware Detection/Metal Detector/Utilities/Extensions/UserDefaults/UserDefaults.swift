//
//  UserDefaults.swift
//  Metal Detector
//
//  Created by iapp on 23/02/24.
//

import UIKit


class CustomUserDefaults : NSObject {
    
    //MARK: - DONE WITH ONBOARDING FLOW
    static var doneOnboardFlow: Bool {
        get {
            let defaults = UserDefaults.standard
            return defaults.bool(forKey: "doneOnboardFlow")
        }
        set {
            let defaults = UserDefaults.standard
            defaults.setValue(newValue, forKey: "doneOnboardFlow")
        }
    }
    
    //MARK: -  DONE WITH FIRST APP SESSION
    static var firstAppSessionDone: Bool {
        get {
            let defaults = UserDefaults.standard
            return defaults.bool(forKey: "firstAppSessionDone")
        }
        set {
            let defaults = UserDefaults.standard
            defaults.setValue(newValue, forKey: "firstAppSessionDone")
        }
    }
    
    
    //MARK: -  CURRENT WIFI
    
    static var currentWifi: String{
        get {
            let defaults = UserDefaults.standard
            return defaults.string(forKey: "currentWifi") ?? ""
        }
        set {
            let defaults = UserDefaults.standard
            defaults.setValue(newValue, forKey: "currentWifi")
        }
    }
    
}
