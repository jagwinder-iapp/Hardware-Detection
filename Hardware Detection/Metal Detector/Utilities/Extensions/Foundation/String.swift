//
//  String.swift
//  FreshMeatMarket
//
//  Created by Lakhwinder Singh on 19/04/17.
//  Copyright © 2017 lakh. All rights reserved.
//

import UIKit

extension String {
    
    /// Substring manupulation.
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
        else { return nil }
        return from ..< to
    }
    
    /// stringToFind must be at least 1 character.
    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var count = 0
        var searchRange: Range<String.Index>?
        while let foundRange = range(of: stringToFind, options: [], range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return count
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    public var trimString: Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
    }
    
    var isEmpty: Bool {
        return count == 0 && trimmingCharacters(in: .whitespaces).count == 0
    }
    
    
    var containCharacters: Bool {
        let letters = NSCharacterSet.letters
        return self.rangeOfCharacter(from: letters.inverted) != nil
    }
    
    var float: Float {
        return Float(self) ?? 0
    }
    
    var int: Int {
        return Int(self) ?? 0
    }
    
    var isValidEmail : Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func attributedTo(font: UIFont,spacing:CGFloat = 0.0, lineSpacing: CGFloat = 0 ,color: UIColor? = nil, alignment: NSTextAlignment = .left, lineBrackMode: NSLineBreakMode = .byWordWrapping) -> NSMutableAttributedString{
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = lineSpacing
        paraStyle.alignment = alignment
        paraStyle.lineBreakMode = lineBrackMode
        let range = NSMakeRange(0, self.count)
        let attrStr = NSMutableAttributedString(string: self)
        attrStr.addAttribute(.font, value: font, range: range)
        attrStr.addAttribute(.kern, value: spacing, range: range)
        attrStr.addAttribute(.paragraphStyle, value: paraStyle, range: range)
        //        NSAttributedString.Key.paragraphStyle: paraStyle,
        if let textColor = color {
            attrStr.addAttribute(.foregroundColor, value: textColor, range: range)
        }
        return attrStr
    }
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    
}

func randomAlphaNumericString(length: Int = 12) -> String {
    let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let allowedCharsCount = UInt32(allowedChars.count)
    var randomString = ""

    for _ in 0 ..< length {
        let randomNum = Int(arc4random_uniform(allowedCharsCount))
        let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
        let newCharacter = allowedChars[randomIndex]
        randomString += String(newCharacter)
    }

    return randomString
}

// MARK: CALCULATE HEIGHT OF TEXT

func heightForText(string: String, width: CGFloat, font: UIFont, valToAdd: CGFloat) -> CGFloat {
    let attrString = NSAttributedString(
        string: string,
        attributes: [NSAttributedString.Key.font: font])
    let size = attrString.boundingRect(
    with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
    options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
    return size.height + valToAdd
}

// MARK: CALCULATE LINE OF TEXT

func calculateMaxLines(string: String, width: CGFloat, font: UIFont) -> Int {
       let maxSize = CGSize(width: width, height: CGFloat(Float.infinity))
       let charSize = font.lineHeight
       let text = string as NSString
       let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
       let linesRoundedUp = Int(ceil(textSize.height/charSize))
       return linesRoundedUp
   }



func calculatePercentage(magnitude: Double,lowerLimit:Double,upperLimit:Double) -> Double {
    let percentage = (magnitude - lowerLimit) / (upperLimit - lowerLimit) * 100.0
    return max(0.0, min(100.0, percentage))
}
