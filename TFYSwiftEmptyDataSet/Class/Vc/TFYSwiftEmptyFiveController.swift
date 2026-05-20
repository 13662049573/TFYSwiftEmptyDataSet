//
//  TFYSwiftEmptyFiveController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

class TFYSwiftEmptyFiveController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindEmptyDataSet(source: self)
    }
}

extension TFYSwiftEmptyFiveController: EmptyDataSetSource {

    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        let label = UILabel()
        label.text = "自定义视图\nCustom View"
        label.textAlignment = .center
        label.textColor = .systemRed
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.backgroundColor = UIColor(hexColor: "ececec")
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        return label
    }
}
