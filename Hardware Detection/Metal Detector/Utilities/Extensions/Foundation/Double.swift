//
//  Double.swift
//  myHealthClub
//
//  Created by TBC on 22/10/19.
//  Copyright © 2019 TBC. All rights reserved.
//

import Foundation
import UIKit

extension Double{
    
    func dayStringFromTime(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, y, h:mm:ss a"
        return dateFormatter.string(from: date)
    }
    
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    func roundNumber(to places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}

func getCurrentMillis()->Int64{
    return  Int64(NSDate().timeIntervalSince1970)
}
