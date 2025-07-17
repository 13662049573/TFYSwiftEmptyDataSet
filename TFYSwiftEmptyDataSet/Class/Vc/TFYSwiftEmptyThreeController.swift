//
//  TFYSwiftEmptyThreeController.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/23.
//

import UIKit

class TFYSwiftEmptyThreeController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension TFYSwiftEmptyThreeController {
    /// 空页面竖直偏移
    /// Empty page vertical offset
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -150 // 向上偏移150
    }
    /// 空页面元素间距
    /// Empty page element vertical space
    override func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 40 // 元素间距40
    }
}

