//
//  UIColor+HexHSB.swift
//  CALayerTest
//
//  Created by liuzhimin on 17/08/2016.
//  Copyright © 2016 liuzhimin. All rights reserved.
//

import UIKit

enum UIColorInputError : Error {
    case MissingHashMarkAsPrefix,
    UnableToScanHexValue,
    MismatchedHexStringLength
}

extension UIColor {
    
    convenience init(hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    convenience init(rgba: String, defaultColor: UIColor = UIColor.clear) {
        guard let color = try? UIColor(rgba_throws: rgba) else {
            self.init(cgColor :defaultColor.cgColor)
            return
        }
        self.init(cgColor: color.cgColor)
    }
    
    convenience init(rgba_throws rgba: String) throws {
        guard rgba.hasPrefix("#") else {
            throw UIColorInputError.MissingHashMarkAsPrefix
        }
        guard let hexString: String = rgba.substring(to: rgba.index(rgba.startIndex, offsetBy: 1)),
            var   hexValue:  UInt32 = 0
            , Scanner(string: hexString).scanHexInt32(&hexValue) else {
                throw UIColorInputError.UnableToScanHexValue
        }
        
        guard hexString.characters.count  == 3
            || hexString.characters.count == 4
            || hexString.characters.count == 6
            || hexString.characters.count == 8 else {
                throw UIColorInputError.MismatchedHexStringLength
        }
        
        switch (hexString.characters.count) {
        case 6:
            self.init(hex6: hexValue)
        default:
            self.init(hex6: hexValue)
        }
    }
    
    convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func set(hueSaturationOrBrightness hsb: HSBA, percentage: CGFloat) -> UIColor {
        var hueValue : CGFloat = 0.0, saturationValue : CGFloat = 0.0, brightnessValue : CGFloat = 0.0, alphaValue : CGFloat = 0.0
        self.getHue(&hueValue, saturation: &saturationValue, brightness: &brightnessValue, alpha: &alphaValue)
        
        switch hsb {
        case .Hue:
            print(hueValue)
            return UIColor(hue: hueValue * percentage, saturation: saturationValue, brightness: brightnessValue, alpha: alphaValue)
        case .Saturation:
            return UIColor(hue: hueValue, saturation: saturationValue * percentage, brightness: brightnessValue, alpha: alphaValue)
        case .Brightness:
            return UIColor(hue: hueValue, saturation: saturationValue, brightness: brightnessValue * percentage, alpha: alphaValue)
        case .Alpha:
            return UIColor(hue: hueValue, saturation: saturationValue, brightness: brightnessValue, alpha: alphaValue * percentage)
        }
    }
    
}

enum HSBA {
    case Hue
    case Saturation
    case Brightness
    case Alpha
}
