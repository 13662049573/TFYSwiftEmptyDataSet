//
//  TFYSwiftEmptySixController.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/23.
//

import UIKit

class TFYSwiftEmptySixController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self;
    }
    

}

extension TFYSwiftEmptySixController {
    
}
