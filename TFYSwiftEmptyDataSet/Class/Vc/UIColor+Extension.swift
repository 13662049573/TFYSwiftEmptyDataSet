//
//  ViewController.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/22.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hexColor: String) {        
        var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
        let hex = hexColor as NSString
        Scanner(string: hex.substring(with: NSRange(location: 0, length: 2))).scanHexInt64(&red)
        Scanner(string: hex.substring(with: NSRange(location: 2, length: 2))).scanHexInt64(&green)
        Scanner(string: hex.substring(with: NSRange(location: 4, length: 2))).scanHexInt64(&blue)
        
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
}
