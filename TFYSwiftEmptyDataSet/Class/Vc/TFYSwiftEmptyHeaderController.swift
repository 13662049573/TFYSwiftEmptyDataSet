//
//  TFYSwiftEmptyHeaderController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

/// 演示：存在 tableHeaderView 时，空态默认仍展示，并自动定位到 header 下方
/// 如需关闭，可让 delegate 返回 `emptyDataSetShouldHideWhenTableHeaderVisible == true`
final class TFYSwiftEmptyHeaderController: TFYSwiftBaseController {

    private var headerEnabled = true
    private var hideWhenHeaderVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        applyTableHeader()
        bindEmptyDataSet(source: self, delegate: self)

        let toggleHeader = UIBarButtonItem(
            title: "切换 Header",
            primaryAction: UIAction { [weak self] _ in
                guard let self else { return }
                self.headerEnabled.toggle()
                self.applyTableHeader()
                self.tableView.reloadEmptyDataSet()
            }
        )
        let toggleHide = UIBarButtonItem(
            title: "切换隐藏",
            primaryAction: UIAction { [weak self] _ in
                guard let self else { return }
                self.hideWhenHeaderVisible.toggle()
                self.tableView.reloadEmptyDataSet()
            }
        )
        navigationItem.leftBarButtonItems = [toggleHeader, toggleHide]
    }

    private func applyTableHeader() {
        if headerEnabled {
            let width = tableView.bounds.width > 0 ? tableView.bounds.width : UIScreen.main.bounds.width
            let header = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 222))
            header.backgroundColor = .systemRed
            let label = UILabel(frame: header.bounds)
            label.text = "tableHeaderView\n（空态显示在此下方）"
            label.textColor = .white
            label.textAlignment = .center
            label.numberOfLines = 0
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            header.addSubview(label)
            tableView.tableHeaderView = header
        } else {
            tableView.tableHeaderView = nil
        }
    }
}

extension TFYSwiftEmptyHeaderController: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        EmptyDataSetContent.title("暂无数据")
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        EmptyDataSetContent.detail("空态会展示在 tableHeaderView 下方区域")
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        UIImage(named: "community_Nodata")
    }
}

extension TFYSwiftEmptyHeaderController: EmptyDataSetDelegate {

    /// 当 `hideWhenHeaderVisible` 为 `true` 且 header 可见时，隐藏空态
    func emptyDataSetShouldHideWhenTableHeaderVisible(_ scrollView: UIScrollView) -> Bool {
        hideWhenHeaderVisible
    }
}
