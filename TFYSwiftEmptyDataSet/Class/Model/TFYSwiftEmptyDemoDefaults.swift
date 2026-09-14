//
//  TFYSwiftEmptyDemoDefaults.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

/// Demo 层共用的默认空态样式（非库 API）
enum TFYSwiftEmptyDemoDefaults {

    static var title: NSAttributedString {
        EmptyDataSetContent.title("暂无数据")
    }

    static var image: UIImage? {
        UIImage(named: "play_fail")
    }

    static var backgroundColor: UIColor {
        .secondarySystemBackground
    }

    static var verticalOffset: CGFloat { -60 }
    static var spaceHeight: CGFloat { 20 }
}
