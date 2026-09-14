//
//  TFYSwiftEmptyChainController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

/// 链式 API 演示：不实现 EmptyDataSetSource / Delegate
final class TFYSwiftEmptyChainController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.emptyDataSetView { view in
            view
                .image(TFYSwiftEmptyDemoDefaults.image)
                .titleLabelString(EmptyDataSetContent.title("链式配置空态"))
                .detailLabelString(EmptyDataSetContent.detail("通过 emptyDataSetView { } 闭包完成配置，无需协议。"))
                .buttonTitle(EmptyDataSetContent.buttonTitle("模拟刷新"), for: .normal)
                .verticalOffset(-40)
                .verticalSpace(16)
                .shouldFadeIn(true)
                .didTapContentView { [weak self] in
                    self?.reloadData()
                }
                .didTapDataButton { [weak self] in
                    self?.reloadData()
                }
        }
    }
}
