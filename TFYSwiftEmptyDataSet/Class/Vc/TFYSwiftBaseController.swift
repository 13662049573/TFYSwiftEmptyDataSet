//
//  TFYSwiftBaseController.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/23.
//

import UIKit

class TFYSwiftBaseController: UIViewController {

    var dataSouceArr:[String] = []
    
    lazy var tableView: TFYSwiftTableView = {
        let tabView = TFYSwiftTableView(frame: view.bounds, style: .plain)
        tabView.delegate = self
        tabView.dataSource = self;
        tabView.emptyDataSetDelegate = self
        tabView.emptyDataSetSource = self
        return tabView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize:15, weight:.bold)
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.green
        
        let items1: UIBarButtonItem = UIBarButtonItem(title: "添加数据", style: .plain, target: self, action: #selector(reloadData))
        let items2: UIBarButtonItem = UIBarButtonItem(title: "删除数据", style: .plain, target: self, action: #selector(deleteData))
        
        items1.setTitleTextAttributes(attributes, for: .normal)
        items2.setTitleTextAttributes(attributes, for: .normal)
        
        self.navigationItem.rightBarButtonItems = [items1,items2]
        
        self.view.addSubview(self.tableView)
    }
    
    @objc func reloadData() {
        
        self.dataSouceArr = ["测试数据1","测试数据2","测试数据3","测试数据4","测试数据5","测试数据6","测试数据7","测试数据8"]
        
        self.tableView.reloadData()
    }
    
    @objc func deleteData() {
        
        self.dataSouceArr.removeAll()
        
        self.tableView.reloadData()
    }
}

extension TFYSwiftBaseController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSouceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {

            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = self.dataSouceArr[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension TFYSwiftBaseController: EmptyDataSetSource,EmptyDataSetDelegate {
    
    ///文本设置
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize:15, weight:.bold)
        attributes[NSAttributedString.Key.foregroundColor] = UIColor(hexColor: "b9b9b9")
        return NSAttributedString.init(string: "暂无数据", attributes: attributes)
    }
    /// 展示的图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "play_fail")
    }
    
    /// 竖直位置
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -100
    }
    
    /// 文字与图片的间距
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 20
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    /// 是否滑动
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    /// 背景颜色
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return UIColor(hexColor: "ececec")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return nil
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? {
        return nil
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        return nil
    }
 
    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return nil
    }
    
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
       
    }
    /// 添加点击事件
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        print("点击了按钮")
    }
}
