//
//  NSAttributedString.swift
//  FreshMeatMarket
//
//  Created by CS_Mac4 on 30/05/17.
//  Copyright © 2017 lakh. All rights reserved.
//

import UIKit

extension NSAttributedString {

    class func attributeTitle(title firstString: String, last lastString: String) -> NSAttributedString {
        let string: String = firstString + (lastString)
        let attString = NSMutableAttributedString(string: string)
        attString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], range: (string as NSString).range(of: firstString))
        attString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], range: (string as NSString).range(of: lastString))
        return attString
    }
}


