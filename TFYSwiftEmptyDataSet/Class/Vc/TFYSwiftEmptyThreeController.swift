//
//  TFYSwiftEmptyThreeController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

class TFYSwiftEmptyThreeController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindEmptyDataSet(source: self)
    }
}

extension TFYSwiftEmptyThreeController: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        TFYSwiftEmptyDemoDefaults.title
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        TFYSwiftEmptyDemoDefaults.image
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        -150
    }

    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        40
    }
}
