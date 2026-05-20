//
//  TFYSwiftEmptySixController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

class TFYSwiftEmptySixController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindEmptyDataSet(source: self)
    }
}

extension TFYSwiftEmptySixController: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        TFYSwiftEmptyDemoDefaults.title
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        TFYSwiftEmptyDemoDefaults.image
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        UIColor(hexColor: "d1f5d3")
    }
}
