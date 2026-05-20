//
//  UIColor+Extension.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

extension UIColor {

    convenience init(hexColor: String, alpha: CGFloat = 1) {
        var hex = hexColor.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hex.hasPrefix("#") { hex.removeFirst() }

        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)

        let r, g, b: CGFloat
        switch hex.count {
        case 6:
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255
            b = CGFloat(rgb & 0x0000FF) / 255
        case 8:
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255
        default:
            r = 0.72
            g = 0.72
            b = 0.72
        }

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
