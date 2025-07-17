//
//  TFYSwiftEmptyOneController.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/23.
//

import UIKit

class TFYSwiftEmptyOneController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension TFYSwiftEmptyOneController {
    /// 空页面标题（纯文本）
    /// Empty page title (plain text)
    override func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor(hexColor: "b9b9b9")
        ]
        return NSAttributedString(string: "暂无数据", attributes: attributes)
    }
    /// 空页面描述
    /// Empty page description
    override func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexColor: "b9b9b9")
        ]
        return NSAttributedString(string: "这里是空页面的描述信息\nThis is the description for the empty page.", attributes: attributes)
    }
    /// 空页面图片
    /// Empty page image
    override func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "play_fail")
    }
}
