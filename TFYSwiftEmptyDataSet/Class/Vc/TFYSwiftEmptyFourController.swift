//
//  TFYSwiftEmptyFourController.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/23.
//

import UIKit

class TFYSwiftEmptyFourController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension TFYSwiftEmptyFourController {
    /// 空页面图片动画
    /// Empty page image animation
    override func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? {
        // 旋转动画
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 1.2
        animation.repeatCount = .infinity
        return animation
    }
    /// 允许图片动画
    /// Allow image animation
    override func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

