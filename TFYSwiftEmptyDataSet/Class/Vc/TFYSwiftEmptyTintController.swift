//
//  TFYSwiftEmptyTintController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

final class TFYSwiftEmptyTintController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindEmptyDataSet(source: self)
    }
}

extension TFYSwiftEmptyTintController: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        EmptyDataSetContent.title("Template 着色")
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        EmptyDataSetContent.detail("通过 imageTintColor 将图片渲染为模板色")
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        UIImage(named: "placeholder_dropbox")
    }

    func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        .systemOrange
    }
}
