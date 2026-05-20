//
//  TFYSwiftEmptyForceDisplayController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

final class TFYSwiftEmptyForceDisplayController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindEmptyDataSet(source: self, delegate: self)
        reloadData()
    }
}

extension TFYSwiftEmptyForceDisplayController: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        EmptyDataSetContent.title("强制显示空态")
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        EmptyDataSetContent.detail("即使列表有数据，也会覆盖显示空态")
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        TFYSwiftEmptyDemoDefaults.image
    }
}

extension TFYSwiftEmptyForceDisplayController: EmptyDataSetDelegate {

    func emptyDataSetShouldBeForcedToDisplay(_ scrollView: UIScrollView) -> Bool {
        true
    }
}
