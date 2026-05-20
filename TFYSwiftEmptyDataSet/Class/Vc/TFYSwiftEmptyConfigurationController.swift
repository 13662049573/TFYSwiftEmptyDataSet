//
//  TFYSwiftEmptyConfigurationController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

final class TFYSwiftEmptyConfigurationController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.setEmptyDataSetConfiguration(
            EmptyDataSetConfiguration(
                title: EmptyDataSetContent.title("配置式 API"),
                detail: EmptyDataSetContent.detail("通过一个配置模型完成空态展示，并由库内部强引用数据源。"),
                image: UIImage(named: "placeholder_remote"),
                imageTintColor: .systemTeal,
                buttonTitle: EmptyDataSetContent.buttonTitle("添加数据"),
                backgroundColor: .secondarySystemBackground,
                verticalOffset: -45,
                verticalSpace: 16,
                imageSize: CGSize(width: 92, height: 92),
                maximumContentWidth: 330,
                accessibilityLabel: "配置式 API 空态，点击按钮添加数据",
                shouldFadeIn: true,
                shouldAllowScroll: false
            ),
            onTapButton: { [weak self] in
                self?.reloadData()
            }
        )
    }
}
