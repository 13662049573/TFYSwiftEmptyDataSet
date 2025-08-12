//
//  TFYSwiftEmptyTwoController.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/23.
//

import UIKit

class TFYSwiftEmptyTwoController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

}

extension TFYSwiftEmptyTwoController {
    /// 空页面按钮标题
    /// Empty page button title
    override func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.systemBlue
        ]
        return NSAttributedString(string: "重试 Try Again", attributes: attributes)
    }
    /// 按钮点击事件
    /// Button tap event
    override func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        // 这里可以添加重试逻辑
        print("点击了空页面按钮（Button tapped on empty page）")
    }
}
