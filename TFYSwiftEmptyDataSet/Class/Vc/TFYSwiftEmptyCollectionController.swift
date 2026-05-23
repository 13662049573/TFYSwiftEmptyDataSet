//
//  TFYSwiftEmptyCollectionController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

final class TFYSwiftEmptyCollectionController: UIViewController {

    private var items: [String] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let width = (UIScreen.main.bounds.width - 16 * 2 - 12) / 2
        layout.itemSize = CGSize(width: width, height: width * 0.75)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let addItem = UIBarButtonItem(title: "添加", primaryAction: UIAction { [weak self] _ in self?.addItems() })
        let clearItem = UIBarButtonItem(title: "清空", primaryAction: UIAction { [weak self] _ in self?.clearItems() })
        navigationItem.rightBarButtonItems = [addItem, clearItem]

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func addItems() {
        items = (1...6).map { "Item \($0)" }
        collectionView.reloadData()
    }

    private func clearItems() {
        items.removeAll()
        collectionView.reloadData()
    }
}

extension TFYSwiftEmptyCollectionController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .secondarySystemFill
        cell.contentView.layer.cornerRadius = 8
        if let label = cell.contentView.viewWithTag(100) as? UILabel {
            label.text = items[indexPath.item]
        } else {
            let label = UILabel(frame: cell.contentView.bounds)
            label.tag = 100
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 15, weight: .medium)
            label.text = items[indexPath.item]
            cell.contentView.addSubview(label)
        }
        return cell
    }
}

extension TFYSwiftEmptyCollectionController: EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        EmptyDataSetContent.title("Collection 为空")
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        EmptyDataSetContent.detail("UICollectionView 同样支持空态。")
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        UIImage(named: "placeholder_foursquare")
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        EmptyDataSetContent.buttonTitle("添加条目")
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        addItems()
    }
}
