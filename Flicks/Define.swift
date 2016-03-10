//
//  Define.swift
//  Flicks
//
//  Created by Tien on 3/9/16.
//  Copyright © 2016 Tien. All rights reserved.
//

import Foundation
import UIKit

let kFlicksErrorDomain = "FlickError"

let kSomethingWentWrongErrorCode = 100

// Appearance
let oddRowColor = 0xF6F6F5
let evenRowColor = 0xFBFBFB

extension UIColor {
    class func colorFromRGB(rgbValue:Int) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    }
}

