//
//  UIColor.swift
//  JeevesAi
//
//  Created by Ajay Negi-iOS-5 on 04/09/23.
//

import Foundation
import UIKit

extension UIColor{
    
    //Static Colors
    static let textViewBorder     = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.36) //#3C3C435C
    static let exampleTitle       = UIColor(red: 0.078, green: 0.09, blue: 0.094, alpha: 1)    //#141718
    static let cellBorder         = UIColor(red: 0.91, green: 0.927, blue: 0.938, alpha: 1)   //#E8ECEF
    static let bubbleRecieved     = UIColor(red: 0.914, green: 0.914, blue: 0.922, alpha: 1) //#E9E9EB
    static let bubbleSent         = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)        //#007AFF

    
    //HEX To UIColor Conversion
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
