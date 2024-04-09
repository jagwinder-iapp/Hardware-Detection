//
//  UILabel.swift
//  Brainy
//
//  Created by Ajay Negi on 18/01/23.
//

import Foundation
import UIKit

//
//  ShimmerLabel.swift
//  ShimmerLabel
//
//  Created by Sergey Makeev on 22.03.2020.
//  Copyright © 2020 SOME projects. All rights reserved.
//

import Foundation
import UIKit

// MARK: STRIKE THROUGH LABEL


extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}

// MARK: UNDERLINE THROUGH LABEL

extension UILabel {
    func underlineText() {
        guard let text = self.text else { return }

        let attributedString = NSMutableAttributedString(string: text)
        let underlineRange = NSRange(location: 0, length: attributedString.length)

        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: underlineRange)

        self.attributedText = attributedString
    }
}
