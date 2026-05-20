//
//  TFYSwiftEmptyTwoController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

class TFYSwiftEmptyTwoController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindEmptyDataSet(source: self, delegate: self)
    }
}

extension TFYSwiftEmptyTwoController: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        TFYSwiftEmptyDemoDefaults.title
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        TFYSwiftEmptyDemoDefaults.image
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        EmptyDataSetContent.buttonTitle("重试")
    }
}

extension TFYSwiftEmptyTwoController: EmptyDataSetDelegate {

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        reloadData()
    }
}
