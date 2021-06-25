//
//  TFYSwiftProtocol.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/22.
//

import Foundation
import UIKit

@objc
public protocol EmptyDataSetDelegate: NSObjectProtocol {
    /// 询问委托，以知道空数据集在显示时是否应该淡入。默认是正确的。
    ///
    /// - Parameter scrollView:通知委托的scrollView子类对象。
    /// - Returns: 如果空数据集应该淡入，则为True。
    @objc optional func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool
    
    /// 询问委托，以知道当项的数量大于0时是否仍应显示空数据集。默认是假的。
    ///
    /// - Parameter scrollView:  通知委托的scrollView子类对象。
    /// - Returns: 如果应该强制显示空数据集，则为True
    @objc optional func emptyDataSetShouldBeForcedToDisplay(_ scrollView: UIScrollView) -> Bool

    /// 询问委托是否应该呈现和显示空数据集。默认是正确的。
    ///
    /// - Parameter scrollView: 通知委托的scrollView子类对象。
    /// - Returns: 如果应该显示空数据集，则为True。
    @objc optional func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool

    /// 向委托请求触摸许可。默认是正确的。
    ///
    /// - Parameter scrollView: 通知委托的scrollView子类对象。
    /// - Returns: 如果空数据集接收到触摸手势，则为True。
    @objc optional func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool

    /// 向委托请求滚动许可。默认是假的。
    ///
    /// - Parameter scrollView: 通知委托的scrollView子类对象。
    /// - Returns: 如果空数据集允许可滚动，则为True。
    @objc optional func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool

    /// 向委托请求图像视图动画权限。默认是假的。
    /// 确保从imageAnimationForEmptyDataSet返回一个有效的CAAnimation对象:
    ///
    /// - Parameter scrollView: 通知委托的scrollView子类对象。
    /// - Returns: 如果空数据集允许动画显示，则为True
    @objc optional func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool

    /// 告诉委托已单击空数据集视图。
    /// 使用此方法可以resignFirstResponder的文本框或搜索栏。
    ///
    /// - Parameters:
    ///   - scrollView: 通知委托的scrollView子类。
    ///   - view: 用户点击的视图
    @objc optional func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView)

    /// 告诉委托操作按钮已被点击。
    ///
    /// - Parameters:
    ///   - scrollView: 通知委托的scrollView子类。
    ///   - button: 用户轻按的按钮
    @objc optional func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton)

    /// 告诉委托将出现空数据集。
    ///
    /// - Parameter scrollView: 通知委托的scrollView子类。
    @objc optional func emptyDataSetWillAppear(_ scrollView: UIScrollView)

    /// 告诉委托已出现空数据集。
    ///
    /// - Parameter scrollView: 通知委托的scrollView子类。
    @objc optional func emptyDataSetDidAppear(_ scrollView: UIScrollView)

    /// 告诉委托空数据集将消失。
    ///
    /// - Parameter scrollView: 通知委托的scrollView子类。
    @objc optional func emptyDataSetWillDisappear(_ scrollView: UIScrollView)

    /// 告诉委托空数据集已消失。
    ///
    /// - Parameter scrollView: 通知委托的scrollView子类。
    @objc optional func emptyDataSetDidDisappear(_ scrollView: UIScrollView)
    
}

@objc
public protocol EmptyDataSetSource: NSObjectProtocol {
    
    /// 向数据源请求数据集的标题。
    /// 如果没有设置任何属性，则数据集默认使用固定的字体样式。如果你想要不同的字体样式，返回一个带属性的字符串。
    ///
    /// - Parameter scrollView: 一个通知数据源的scrollView子类。
    /// - Returns: 用于数据集标题、组合字体、文本颜色、文本段落样式等的带属性字符串。
    @objc optional func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    
    /// 向数据源请求数据集的描述。
    /// 如果没有设置任何属性，则数据集默认使用固定的字体样式。如果你想要不同的字体样式，返回一个带属性的字符串。
    ///
    /// - Parameter scrollView: 一个通知数据源的scrollView子类。
    /// - Returns: 用于数据集描述文本、组合字体、文本颜色、文本段落样式等的带属性字符串。
    @objc optional func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    
    /// 向数据源请求数据集的映像。
    ///
    /// - Parameter scrollView: 通知数据源的scrollView子类。
    /// - Returns: 数据集的映像。
    @objc optional func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage?
    
    /// 向数据源请求图像数据集的色调颜色。默认是零。
    ///
    /// - Parameter scrollView: 通知数据源的scrollView子类对象。
    /// - Returns: 用于着色数据集图像的颜色。
    @objc optional func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor?

    /// 向数据源请求数据集的图像动画。
    ///
    /// - Parameter scrollView: 通知委托的scrollView子类对象。
    /// - Returns: 动画形象
    @objc optional func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation?
    
    /// 向数据源请求要用于指定按钮状态的标题。
    /// 如果没有设置任何属性，则数据集默认使用固定的字体样式。如果你想要不同的字体样式，返回一个带属性的字符串。
    ///
    /// - Parameters:
    ///   - scrollView: 通知数据源的scrollView子类对象。
    ///   - forState: 使用指定标题的状态。可能的值在UIControlState中描述。
    /// - Returns: 用于数据集按钮标题、组合字体、文本颜色、文本段落样式等的带属性字符串。
    @objc optional func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString?
    
    /// 请求数据源提供用于指定按钮状态的图像。
    /// 这个方法将覆盖buttonTitleForEmptyDataSet:forState:并且只显示图像，不包含任何文本。
    ///
    /// - Parameters:
    ///   - scrollView: 通知数据源的scrollView子类对象。
    ///   - forState: 使用指定标题的状态。可能的值在UIControlState中描述。
    /// - Returns: 数据集按钮imageview的图像。
    @objc optional func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage?
    
    /// 向数据源请求用于指定按钮状态的背景图像。
    /// 这个调用没有默认的样式。
    ///
    /// - Parameters:
    ///   - scrollView: 通知数据源的scrollView子类。
    ///   - forState: 使用指定映像的状态。这些值在UIControlState中描述。
    /// - Returns: 用于数据集按钮标题、组合字体、文本颜色、文本段落样式等的带属性字符串。
    @objc optional func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage?

    /// 向数据源请求数据集的背景颜色。默认是清晰的颜色。
    ///
    /// - Parameter scrollView: 通知数据源的scrollView子类对象。
    /// - Returns: 要应用于数据集背景视图的颜色。
    @objc optional func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor?

    /// 请求数据源显示一个自定义视图，而不是默认视图，如标签、imageview和按钮。默认是零。
    /// 使用此方法可以显示用于加载反馈的活动视图指示器，或用于完整的自定义空数据集。
    /// 返回自定义视图将忽略-offsetForEmptyDataSet和-spaceHeightForEmptyDataSet配置。
    ///
    /// - Parameter scrollView: 通知委托的scrollView子类对象。
    /// - Returns: 自定义视图。
    @objc optional func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView?

    /// 向数据源请求内容垂直对齐的偏移量。默认值为0。
    ///
    /// - Parameter scrollView: 通知委托的scrollView子类对象。
    /// - Returns: 垂直对齐的偏移量。
    @objc optional func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat

    /// 向数据源请求元素之间的垂直空间。默认是11分。
    ///
    /// - Parameter scrollView: 通知委托的scrollView子类对象。
    /// - Returns: 元素之间的空间高度。
    @objc optional func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat
}
