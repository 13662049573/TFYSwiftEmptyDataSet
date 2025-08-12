//
//  TFYSwiftEmptyEightController.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/23.
//

import UIKit

class TFYSwiftEmptyEightController: TFYSwiftBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}

extension TFYSwiftEmptyEightController {
    /// 标题
    override func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.systemPurple
        ]
        return NSAttributedString(string: "全部功能演示\nAll Features", attributes: attr)
    }
    /// 描述
    override func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.systemGray
        ]
        return NSAttributedString(string: "本页面演示所有空页面协议功能\nShow all empty page features.", attributes: attr)
    }
    /// 图片
    override func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "play_fail")
    }
    /// 图片动画
    override func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 1.2
        animation.repeatCount = .infinity
        return animation
    }
    /// 按钮标题
    override func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.systemBlue
        ]
        return NSAttributedString(string: "操作按钮 Action", attributes: attr)
    }
    /// 按钮图片
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return UIImage(named: "module_vip")
    }
    /// 按钮背景
    override func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return UIImage(named: "module_btn_bg")
    }
    /// 背景色
    override func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return UIColor(hexColor: "ececec")
    }
    /// 自定义视图
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        return nil // 不用自定义视图，展示全部元素
    }
    /// 竖直偏移
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -80
    }
    /// 元素间距
    override func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 25
    }
    /// 是否显示
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    /// 是否允许点击
    override func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    /// 是否允许滚动
    override func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    /// 是否强制显示
    func emptyDataSetShouldBeForcedToDisplay(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    /// 是否允许图片动画
    override func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    /// 点击空白视图
    override func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        print("点击了空白视图（Tapped empty view）")
    }
    /// 点击按钮
    override func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        print("点击了按钮（Tapped button）")
    }
    /// 将要出现
    func emptyDataSetWillAppear(_ scrollView: UIScrollView) {
        print("空页面将要出现（Will appear）")
    }
    /// 已经出现
    func emptyDataSetDidAppear(_ scrollView: UIScrollView) {
        print("空页面已经出现（Did appear）")
    }
    /// 将要消失
    func emptyDataSetWillDisappear(_ scrollView: UIScrollView) {
        print("空页面将要消失（Will disappear）")
    }
    /// 已经消失
    func emptyDataSetDidDisappear(_ scrollView: UIScrollView) {
        print("空页面已经消失（Did disappear）")
    }
}

