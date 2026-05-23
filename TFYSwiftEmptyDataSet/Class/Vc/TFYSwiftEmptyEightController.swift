//
//  TFYSwiftEmptyEightController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

class TFYSwiftEmptyEightController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindEmptyDataSet(source: self, delegate: self)
    }
}

extension TFYSwiftEmptyEightController: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        EmptyDataSetContent.title("全部功能演示")
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        EmptyDataSetContent.detail("本页面演示所有空页面协议功能")
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        TFYSwiftEmptyDemoDefaults.image
    }

    func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 1.2
        animation.repeatCount = .infinity
        return animation
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        EmptyDataSetContent.buttonTitle("操作按钮")
    }

    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        UIImage(named: "module_btn_bg")
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        UIColor(hexColor: "ececec")
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        -80
    }

    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        25
    }
}

extension TFYSwiftEmptyEightController: EmptyDataSetDelegate {

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        true
    }

    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
        true
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        print("点击了空白视图")
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        print("点击了按钮")
    }

    func emptyDataSetWillAppear(_ scrollView: UIScrollView) {
        print("空页面将要出现")
    }

    func emptyDataSetDidAppear(_ scrollView: UIScrollView) {
        print("空页面已经出现")
    }

    func emptyDataSetWillDisappear(_ scrollView: UIScrollView) {
        print("空页面将要消失")
    }

    func emptyDataSetDidDisappear(_ scrollView: UIScrollView) {
        print("空页面已经消失")
    }
}
