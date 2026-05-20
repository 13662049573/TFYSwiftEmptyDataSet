//
//  TFYSwiftEmptySevenController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

class TFYSwiftEmptySevenController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindEmptyDataSet(source: self, delegate: self)
    }
}

extension TFYSwiftEmptySevenController: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        TFYSwiftEmptyDemoDefaults.title
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        TFYSwiftEmptyDemoDefaults.image
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        EmptyDataSetContent.buttonTitle("操作按钮")
    }

    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        UIImage(named: "module_btn_bg")
    }
}

extension TFYSwiftEmptySevenController: EmptyDataSetDelegate {

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        print("点击了图片按钮")
    }
}
