//
//  TFYSwiftTableView.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/23.
//

import UIKit

class TFYSwiftTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .white
        estimatedSectionFooterHeight = 0.01
        estimatedSectionHeaderHeight = 0.01
        tableFooterView = UIView()
        tableHeaderView = UIView()
        estimatedRowHeight = 100
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
