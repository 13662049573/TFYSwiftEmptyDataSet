//
//  ViewController.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/22.
//

import UIKit

class ViewController: TFYSwiftBaseController {

    let dataArr:[String] = ["常用没有数据加载空图","带有按钮的空图","更改位置的空图","带有动画的空图","自定义文字的空图","纯文本显示","纯文本加按钮","自定义按钮"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "首页";
        
        self.dataSouceArr = self.dataArr
        
        self.navigationItem.rightBarButtonItems = []
    }
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var controller: TFYSwiftBaseController? = nil
        let titles: String = self.dataSouceArr[indexPath.row]
        if indexPath.row == 0 {
            let vc: TFYSwiftEmptyOneController = TFYSwiftEmptyOneController()
            vc.navigationItem.title = titles
            controller = vc
        } else if indexPath.row == 1 {
            let vc: TFYSwiftEmptyTwoController = TFYSwiftEmptyTwoController()
            vc.navigationItem.title = titles
            controller = vc
        } else if indexPath.row == 2 {
            let vc: TFYSwiftEmptyThreeController = TFYSwiftEmptyThreeController()
            vc.navigationItem.title = titles
            controller = vc
        } else if indexPath.row == 3 {
            let vc: TFYSwiftEmptyFourController = TFYSwiftEmptyFourController()
            vc.navigationItem.title = titles
            controller = vc
        } else if indexPath.row == 4 {
            let vc: TFYSwiftEmptyFiveController = TFYSwiftEmptyFiveController()
            vc.navigationItem.title = titles
            controller = vc
        } else if indexPath.row == 5 {
            let vc: TFYSwiftEmptySixController = TFYSwiftEmptySixController()
            vc.navigationItem.title = titles
            controller = vc
        } else if indexPath.row == 6 {
            let vc: TFYSwiftEmptySevenController = TFYSwiftEmptySevenController()
            vc.navigationItem.title = titles
            controller = vc
        } else if indexPath.row == 7 {
            let vc: TFYSwiftEmptyEightController = TFYSwiftEmptyEightController()
            vc.navigationItem.title = titles
            controller = vc
        }
        self.navigationController?.pushViewController(controller!, animated: true)
    }
}
