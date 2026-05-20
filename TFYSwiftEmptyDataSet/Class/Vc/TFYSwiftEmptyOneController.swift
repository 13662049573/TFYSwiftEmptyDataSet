//
//  TFYSwiftEmptyOneController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

class TFYSwiftEmptyOneController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindEmptyDataSet(source: self)
    }
}

extension TFYSwiftEmptyOneController: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        EmptyDataSetContent.title("暂无数据")
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        EmptyDataSetContent.detail("这里是空页面的描述信息")
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        TFYSwiftEmptyDemoDefaults.image
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        TFYSwiftEmptyDemoDefaults.verticalOffset
    }

    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        TFYSwiftEmptyDemoDefaults.spaceHeight
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        TFYSwiftEmptyDemoDefaults.backgroundColor
    }
}
