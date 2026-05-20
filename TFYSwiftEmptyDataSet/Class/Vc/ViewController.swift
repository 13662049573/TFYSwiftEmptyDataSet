//
//  ViewController.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

final class ViewController: TFYSwiftBaseController {

    private let demos = TFYSwiftEmptyDemo.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TFYSwiftEmptyDataSet"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        demos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoCell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "demoCell")
        let demo = demos[indexPath.row]
        cell.textLabel?.text = demo.title
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.detailTextLabel?.text = demo.subtitle
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.detailTextLabel?.numberOfLines = 2
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let demo = demos[indexPath.row]
        let controller = demo.makeViewController()
        controller.navigationItem.title = demo.title
        navigationController?.pushViewController(controller, animated: true)
    }
}
