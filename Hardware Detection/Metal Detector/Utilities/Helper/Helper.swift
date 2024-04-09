//
//  Helper.swift
//  Metal Detector
//
//  Created by iapp on 01/03/24.
//

import Foundation


class Helper: NSObject {
    
    //MARK:- DispatchQueue Methods
    static func dispatchDelay(deadLine: DispatchTime , execute : @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: deadLine, execute: execute)
    }
    static func dispatchMain(execute : @escaping () -> Void) {
        DispatchQueue.main.async(execute: execute)
    }
    
    static func dispatchBackground(execute : @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async(execute: execute)
    }
    static func dispatchGlobal(execute : @escaping () -> Void) {
        DispatchQueue.global().async(execute: execute)
    }
    
    static func dispatchMainAfter(time : DispatchTime , execute :@escaping (() -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: time, execute: execute)
    }
}
