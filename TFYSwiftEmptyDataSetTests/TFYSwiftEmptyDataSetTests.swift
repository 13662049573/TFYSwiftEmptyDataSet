//
//  TFYSwiftEmptyDataSetTests.swift
//  TFYSwiftEmptyDataSetTests
//

import XCTest
@testable import TFYSwiftEmptyDataSet

final class TFYSwiftEmptyDataSetTests: XCTestCase {

    func testEmptyTableShowsEmptyDataSet() {
        let harness = TableHarness(items: [])

        harness.tableView.reloadData()

        XCTAssertTrue(harness.tableView.isEmptyDataSetVisible)
        XCTAssertEqual(harness.tableView.emptyDataSetItemCount, 0)
    }

    func testEmptyDataSetIsAboveTableViewInternalSubviews() {
        let harness = TableHarness(items: [])

        harness.tableView.reloadData()

        XCTAssertTrue(harness.tableView.subviews.last is TFYSwiftEmptyDataSetView)
    }

    func testEmptyDataSetContentIsVisibleAfterReload() {
        let harness = TableHarness(items: [])

        harness.tableView.reloadData()
        let emptyView = try? XCTUnwrap(harness.tableView.subviews.compactMap { $0 as? TFYSwiftEmptyDataSetView }.last)

        XCTAssertEqual(emptyView?.contentView.alpha, 1)
    }

    func testEmptyDataSetContentIsVisibleAfterHideThenShowAgain() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let harness = TableHarness(items: [])
        harness.allowsFadeIn = true
        window.addSubview(harness.tableView)
        window.isHidden = false

        UIView.setAnimationsEnabled(false)
        harness.tableView.reloadData()
        harness.items = ["A"]
        harness.tableView.reloadData()
        harness.items.removeAll()
        harness.tableView.reloadData()
        UIView.setAnimationsEnabled(true)

        let emptyView = try? XCTUnwrap(harness.tableView.subviews.compactMap { $0 as? TFYSwiftEmptyDataSetView }.last)
        XCTAssertTrue(harness.tableView.isEmptyDataSetVisible)
        XCTAssertEqual(emptyView?.contentView.alpha, 1)
    }

    func testNonEmptyTableHidesEmptyDataSet() {
        let harness = TableHarness(items: ["A", "B"])

        harness.tableView.reloadData()

        XCTAssertFalse(harness.tableView.isEmptyDataSetVisible)
        XCTAssertEqual(harness.tableView.emptyDataSetItemCount, 2)
    }

    func testLoadingStateCanDisplayOverExistingItems() {
        let harness = TableHarness(items: ["A"])

        harness.tableView.emptyDataSetIsLoading = true
        harness.tableView.reloadData()

        XCTAssertTrue(harness.tableView.isEmptyDataSetVisible)
        XCTAssertEqual(harness.tableView.emptyDataSetItemCount, 1)
    }

    func testForcedEmptyDataSetStaysAboveVisibleRows() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let harness = TableHarness(items: ["A", "B"])
        harness.forceDisplay = true
        window.addSubview(harness.tableView)
        window.isHidden = false

        harness.tableView.reloadData()
        harness.tableView.layoutIfNeeded()

        XCTAssertTrue(harness.tableView.isEmptyDataSetVisible)
        XCTAssertTrue(harness.tableView.subviews.last is TFYSwiftEmptyDataSetView)
    }

    func testDisablingEmptyDataSetInvalidatesViewAndRestoresScroll() {
        let harness = TableHarness(items: [])
        harness.tableView.reloadData()
        XCTAssertFalse(harness.tableView.isScrollEnabled)

        harness.tableView.isEmptyDataSetEnabled = false

        XCTAssertFalse(harness.tableView.isEmptyDataSetVisible)
        XCTAssertTrue(harness.tableView.isScrollEnabled)
    }

    func testContentBuilderUsesDynamicTypeFonts() {
        let title = EmptyDataSetContent.title("暂无数据")
        let detail = EmptyDataSetContent.detail("描述")

        XCTAssertNotNil(title.attribute(.font, at: 0, effectiveRange: nil))
        XCTAssertNotNil(detail.attribute(.font, at: 0, effectiveRange: nil))
    }

    func testConfigurationAPIKeepsSourceAlive() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: .plain)
        let dataSource = StaticTableDataSource(items: [])
        tableView.dataSource = dataSource

        tableView.setEmptyDataSetConfiguration(
            EmptyDataSetConfiguration(
                title: EmptyDataSetContent.title("Empty"),
                shouldFadeIn: false
            )
        )
        tableView.reloadData()

        XCTAssertTrue(tableView.isEmptyDataSetVisible)
    }
}

private final class TableHarness: NSObject, UITableViewDataSource, EmptyDataSetSource, EmptyDataSetDelegate {

    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: .plain)
    var items: [String]
    var allowsFadeIn = false
    var forceDisplay = false

    init(items: [String]) {
        self.items = items
        super.init()
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell(style: .default, reuseIdentifier: nil)
    }

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        EmptyDataSetContent.title("Empty")
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        false
    }

    func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool {
        allowsFadeIn
    }

    func emptyDataSetShouldBeForcedToDisplay(_ scrollView: UIScrollView) -> Bool {
        forceDisplay
    }
}

private final class StaticTableDataSource: NSObject, UITableViewDataSource {
    let items: [String]

    init(items: [String]) {
        self.items = items
        super.init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell(style: .default, reuseIdentifier: nil)
    }
}
