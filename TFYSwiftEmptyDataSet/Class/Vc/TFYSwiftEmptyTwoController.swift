//
//  TFYSwiftEmptyTwoController.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/23.
//

import UIKit

class TFYSwiftEmptyTwoController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

}

extension TFYSwiftEmptyTwoController {
 
    override func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        
        return NSAttributedString(string: "我是一个按钮")
    }
}
