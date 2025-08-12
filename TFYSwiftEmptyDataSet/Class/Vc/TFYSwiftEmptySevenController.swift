//
//  TFYSwiftEmptySevenController.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/23.
//

import UIKit

class TFYSwiftEmptySevenController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

}

extension TFYSwiftEmptySevenController {
 
    override func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return UIImage(named: "module_btn_bg")
    }
    
    /// 按钮点击事件
    /// Button tap event
    override func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        print("点击了图片按钮（Button image tapped on empty page）")
    }
    
    override func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.systemBlue
        ]
        return NSAttributedString(string: "操作按钮 Action", attributes: attr)
    }
}

