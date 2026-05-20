//
//  TFYSwiftEmptyFourController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

class TFYSwiftEmptyFourController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindEmptyDataSet(source: self, delegate: self)
    }
}

extension TFYSwiftEmptyFourController: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        TFYSwiftEmptyDemoDefaults.title
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
}

extension TFYSwiftEmptyFourController: EmptyDataSetDelegate {

    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
        true
    }
}
