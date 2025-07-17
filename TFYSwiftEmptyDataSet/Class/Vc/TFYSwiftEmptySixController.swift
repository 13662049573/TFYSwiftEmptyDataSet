//
//  TFYSwiftEmptySixController.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/23.
//

import UIKit

class TFYSwiftEmptySixController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

}

extension TFYSwiftEmptySixController {
    /// 空页面背景色
    /// Empty page background color
    override func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return UIColor(hexColor: "d1f5d3") // 浅绿色背景
    }
}
