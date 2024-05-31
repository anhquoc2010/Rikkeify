//
//  UIColor+Ext.swift
//  Rikkeify
//
//  Created by QuocLA on 20/05/2024.
//

import UIKit

// MARK: Support Select Color From Image
extension UIColor {
    convenience init(from hsl : HSLColor) {
        self.init(hue: hsl.hue, saturation: hsl.saturation, brightness: hsl.brightness, alpha: hsl.alpha)
    }
    var hslColor: HSLColor {
        get {
            return HSLColor(from: self)
        }
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
