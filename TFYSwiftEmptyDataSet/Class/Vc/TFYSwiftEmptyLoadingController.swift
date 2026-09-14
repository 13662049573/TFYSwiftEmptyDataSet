//
//  TFYSwiftEmptyLoadingController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

final class TFYSwiftEmptyLoadingController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindEmptyDataSet(source: self)
        simulateLoading()
    }

    override func deleteData() {
        simulateLoading()
    }

    private func simulateLoading() {
        dataSouceArr.removeAll()
        tableView.emptyDataSetIsLoading = true
        tableView.reloadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) { [weak self] in
            guard let self else { return }
            self.tableView.emptyDataSetIsLoading = false
            self.reloadData()
        }
    }
}

extension TFYSwiftEmptyLoadingController: EmptyDataSetSource {

    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        EmptyDataSetContent.makeLoadingView(text: "加载中…")
    }
}

extension TFYSwiftEmptyLoadingController: EmptyDataSetDelegate {

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        false
    }
}
