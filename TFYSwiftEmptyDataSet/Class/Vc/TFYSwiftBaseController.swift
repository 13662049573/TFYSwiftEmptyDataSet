//
//  TFYSwiftBaseController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

class TFYSwiftBaseController: UIViewController {

    var dataSouceArr: [String] = []

    lazy var tableView: TFYSwiftTableView = {
        let tableView = TFYSwiftTableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let addItem = UIBarButtonItem(
            title: "添加数据",
            primaryAction: UIAction { [weak self] _ in self?.reloadData() }
        )
        let deleteItem = UIBarButtonItem(
            title: "删除数据",
            primaryAction: UIAction { [weak self] _ in self?.deleteData() }
        )
        navigationItem.rightBarButtonItems = [addItem, deleteItem]

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    /// 子类在 `viewDidLoad` 中调用，绑定空态数据源
    /// - Note: 设置 `emptyDataSetSource` 时库内部已自动触发刷新，无需手动 reload
    func bindEmptyDataSet(source: EmptyDataSetSource, delegate: EmptyDataSetDelegate? = nil) {
        tableView.emptyDataSetDelegate = delegate
        tableView.emptyDataSetSource = source
    }

    func reloadData() {
        dataSouceArr = (1...8).map { "测试数据 \($0)" }
        tableView.reloadData()
    }

    func deleteData() {
        dataSouceArr.removeAll()
        tableView.reloadData()
    }
}

extension TFYSwiftBaseController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSouceArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = dataSouceArr[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
