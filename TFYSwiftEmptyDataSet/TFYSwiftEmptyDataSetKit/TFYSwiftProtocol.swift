//
//  TFYSwiftProtocol.swift
//  TFYSwiftEmptyDataSet
//
//  空数据集协议定义：
//  - `EmptyDataSetDelegate`  控制空态的展示时机、交互行为与生命周期回调
//  - `EmptyDataSetSource`    提供空态展示所需的内容（图片、文字、按钮、自定义视图等）
//

import UIKit

// MARK: - EmptyDataSetDelegate

/// 空数据集行为回调协议。
///
/// 用于控制空态的展示策略、交互能力以及监听生命周期事件。
/// 通过 `UIScrollView.emptyDataSetDelegate` 设置（弱引用）。
///
/// 实现时仅需重写关心的方法，未实现的方法将走 `extension` 中的默认值。
///
/// - Important: 协议对象以弱引用持有，请确保实现者（通常是 `UIViewController`）的生命周期长于 `scrollView`。
public protocol EmptyDataSetDelegate: AnyObject {

    /// 空态视图首次出现时是否执行淡入动画。
    ///
    /// - Parameter scrollView: 触发空态的滚动视图
    /// - Returns: 返回 `true` 时，从隐藏到显示的转场会带 0.25s 淡入；默认 `true`
    /// - Note: 仅在「不可见 → 可见」的转场触发动画；后续刷新不会重复淡入，避免闪烁
    func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool

    /// 即使列表中存在数据，是否仍强制展示空态。
    ///
    /// - Parameter scrollView: 触发空态的滚动视图
    /// - Returns: 返回 `true` 时即使 `itemsCount > 0` 也会展示空态；默认 `false`
    /// - SeeAlso: `UIScrollView.emptyDataSetIsLoading` 加载态强制展示
    func emptyDataSetShouldBeForcedToDisplay(_ scrollView: UIScrollView) -> Bool

    /// 是否允许展示空态（总开关）。
    ///
    /// - Parameter scrollView: 触发空态的滚动视图
    /// - Returns: 返回 `false` 时不展示任何空态视图；默认 `true`
    /// - Note: 与 `UIScrollView.isEmptyDataSetEnabled` 的差异：此处针对单次刷新；后者为持久属性
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool

    /// `tableHeaderView` 可见时是否隐藏空态。
    ///
    /// - Parameter scrollView: 触发空态的滚动视图
    /// - Returns: 返回 `true` 时若 `tableView.tableHeaderView` 高度 > 0 则不展示空态；默认 `false`
    /// - Note: 默认行为是「即使存在 header 也展示」，空态视图会自动定位到 header 下方
    ///         的可视区域内；返回 `true` 可恢复经典的「有 header 则隐藏」行为
    func emptyDataSetShouldHideWhenTableHeaderVisible(_ scrollView: UIScrollView) -> Bool

    /// 空态视图是否允许接收点击手势。
    ///
    /// - Parameter scrollView: 触发空态的滚动视图
    /// - Returns: 返回 `true` 时点击空态视图会触发 `emptyDataSet(_:didTapView:)`；默认 `true`
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool

    /// 空态展示期间是否允许滚动 `scrollView`。
    ///
    /// - Parameter scrollView: 触发空态的滚动视图
    /// - Returns: 返回 `false` 时空态期间临时禁用滚动，空态消失后自动恢复原值；默认 `false`
    /// - Note: 原 `isScrollEnabled` 会被保存，`invalidate` 时还原，无需调用方手动管理
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool

    /// 是否在展示时为插图执行 `imageAnimation`。
    ///
    /// - Parameter scrollView: 触发空态的滚动视图
    /// - Returns: 返回 `true` 时会把 `EmptyDataSetSource.imageAnimation` 应用到图片图层；默认 `false`
    /// - SeeAlso: `EmptyDataSetSource.imageAnimation(forEmptyDataSet:)`
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool

    /// 用户点击空态视图（非按钮区域）回调。
    ///
    /// - Parameters:
    ///   - scrollView: 触发空态的滚动视图
    ///   - view: 接收点击的子视图（通常为 `TFYSwiftEmptyDataSetView`）
    /// - Note: 需 `emptyDataSetShouldAllowTouch` 返回 `true` 才会触发
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView)

    /// 用户点击空态视图中按钮回调。
    ///
    /// - Parameters:
    ///   - scrollView: 触发空态的滚动视图
    ///   - button: 被点击的按钮实例
    /// - Note: 按钮内容通过 `EmptyDataSetSource.buttonTitle`/`buttonImage`/`buttonBackgroundImage` 配置
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton)

    /// 空态即将出现（已确定要展示但尚未完成布局/动画）。
    /// - Parameter scrollView: 触发空态的滚动视图
    func emptyDataSetWillAppear(_ scrollView: UIScrollView)

    /// 空态已完成出现（布局与首次淡入动画已发起）。
    /// - Parameter scrollView: 触发空态的滚动视图
    func emptyDataSetDidAppear(_ scrollView: UIScrollView)

    /// 空态即将消失（如数据到来或调用 `invalidate`）。
    /// - Parameter scrollView: 触发空态的滚动视图
    func emptyDataSetWillDisappear(_ scrollView: UIScrollView)

    /// 空态已完成消失（视图已隐藏，滚动状态已恢复）。
    /// - Parameter scrollView: 触发空态的滚动视图
    func emptyDataSetDidDisappear(_ scrollView: UIScrollView)
}

/// `EmptyDataSetDelegate` 的默认实现，保证调用方仅需重写关心的方法。
public extension EmptyDataSetDelegate {

    /// 默认 `true`：首次展示带淡入动画
    func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool { true }

    /// 默认 `false`：有数据时不强制展示空态
    func emptyDataSetShouldBeForcedToDisplay(_ scrollView: UIScrollView) -> Bool { false }

    /// 默认 `true`：允许展示空态
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool { true }

    /// 默认 `false`：即使存在 `tableHeaderView` 也展示空态，并定位于 header 下方
    func emptyDataSetShouldHideWhenTableHeaderVisible(_ scrollView: UIScrollView) -> Bool { false }

    /// 默认 `true`：允许点击空态视图
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool { true }

    /// 默认 `false`：空态期间禁用滚动，消失后自动还原
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { false }

    /// 默认 `false`：不为插图应用动画
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool { false }

    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {}
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {}

    func emptyDataSetWillAppear(_ scrollView: UIScrollView) {}
    func emptyDataSetDidAppear(_ scrollView: UIScrollView) {}
    func emptyDataSetWillDisappear(_ scrollView: UIScrollView) {}
    func emptyDataSetDidDisappear(_ scrollView: UIScrollView) {}
}

// MARK: - EmptyDataSetSource

/// 空数据集内容数据源协议。
///
/// 用于提供空态展示所需的全部内容元素（图片、文字、按钮、背景、自定义视图等）。
/// 通过 `UIScrollView.emptyDataSetSource` 设置（弱引用）。
///
/// 实现时仅需重写关心的方法，未实现的方法将走 `extension` 中的默认值。
///
/// 展示元素的优先级与互斥关系：
/// - 若实现 `customView(forEmptyDataSet:)` 返回非 `nil`，则忽略 `image` / `title` / `description` / `button`
/// - 若未提供 `customView`，则按 `image → title → description → button` 顺序竖向排列
/// - 各元素之间的垂直间距由 `spaceHeight(forEmptyDataSet:)` 控制
///
/// - Important: 协议对象以弱引用持有；切勿在实现中触发 `reloadData()` 否则可能导致递归刷新
public protocol EmptyDataSetSource: AnyObject {

    /// 空态主标题文字。
    ///
    /// - Parameter scrollView: 请求内容的滚动视图
    /// - Returns: 富文本标题；返回 `nil` 时不显示标题
    /// - Tip: 推荐使用 `EmptyDataSetContent.title(_:)` 创建带默认样式的富文本
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?

    /// 空态描述文字（位于标题下方）。
    ///
    /// - Parameter scrollView: 请求内容的滚动视图
    /// - Returns: 富文本描述；返回 `nil` 时不显示描述
    /// - Tip: 推荐使用 `EmptyDataSetContent.detail(_:)` 创建带默认样式的富文本
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?

    /// 空态插图。
    ///
    /// - Parameter scrollView: 请求内容的滚动视图
    /// - Returns: 插图；返回 `nil` 时不显示图片
    /// - Note: 资源建议同时提供 `@2x` 与 `@3x`，避免在 3x 设备上偏小
    /// - SeeAlso: `imageTintColor`、`imageSize`、`imageMaxWidth`、`imageAnimation`
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage?

    /// 插图模板染色色值（template tint）。
    ///
    /// - Parameter scrollView: 请求内容的滚动视图
    /// - Returns: 染色色值；返回非 `nil` 时图片以 `.alwaysTemplate` 模式渲染并染色；默认 `nil`
    /// - Note: 仅对支持模板渲染的图片资源生效
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor?

    /// 自定义插图展示尺寸（pt）。
    ///
    /// - Parameter scrollView: 请求内容的滚动视图
    /// - Returns: 自定义尺寸；返回 `nil` 时按图片自身尺寸结合 `imageMaxWidth` 自动计算；默认 `nil`
    /// - Note: 同时指定 `width` 与 `height` 才会生效；其一为 0 视为无效
    func imageSize(forEmptyDataSet scrollView: UIScrollView) -> CGSize?

    /// 插图最大宽度限制（pt）。
    ///
    /// - Parameter scrollView: 请求内容的滚动视图
    /// - Returns: 最大宽度；默认 `EmptyDataSetContent.defaultImageMaxWidth`（280pt）
    /// - Note: 当 `imageSize` 未提供时，最终宽度 = `min(图片宽度, 此值)`；若图片偏小则自动放大至此值以保证视觉一致
    func imageMaxWidth(forEmptyDataSet scrollView: UIScrollView) -> CGFloat

    /// 插图动画（仅当 `emptyDataSetShouldAnimateImageView` 返回 `true` 时生效）。
    ///
    /// - Parameter scrollView: 请求内容的滚动视图
    /// - Returns: `CAAnimation` 实例；返回 `nil` 时不应用动画；默认 `nil`
    /// - Tip: 典型用法：旋转动画（`CABasicAnimation(keyPath: "transform.rotation")`）
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation?

    /// 按钮文字。
    ///
    /// - Parameters:
    ///   - scrollView: 请求内容的滚动视图
    ///   - state: 按钮状态（`.normal` / `.highlighted` 等）
    /// - Returns: 富文本标题；返回 `nil` 时不显示按钮文字
    /// - Note: 与 `buttonImage` 互斥；优先级 `image > title`，两者同时存在时仅显示 image
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString?

    /// 按钮图片。
    ///
    /// - Parameters:
    ///   - scrollView: 请求内容的滚动视图
    ///   - state: 按钮状态
    /// - Returns: 按钮图片；返回 `nil` 时尝试使用 `buttonTitle`
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage?

    /// 按钮背景图。
    ///
    /// - Parameters:
    ///   - scrollView: 请求内容的滚动视图
    ///   - state: 按钮状态
    /// - Returns: 背景图；返回 `nil` 时按钮无背景；仅在使用 `buttonTitle` 时生效
    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage?

    /// 空态视图整体背景色。
    ///
    /// - Parameter scrollView: 请求内容的滚动视图
    /// - Returns: 背景色；返回 `nil` 时使用默认透明背景
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor?

    /// 完全自定义空态视图。
    ///
    /// - Parameter scrollView: 请求内容的滚动视图
    /// - Returns: 完全自定义的视图实例；返回非 `nil` 时会忽略 `image` / `title` / `description` / `button`
    /// - Note: 自定义视图会被居中（受 `verticalOffset` 影响）；若设置了 `bounds.size`，则按尺寸固定；否则不超过容器边界
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView?

    /// 内容整体的垂直偏移量（pt）。
    ///
    /// - Parameter scrollView: 请求内容的滚动视图
    /// - Returns: 偏移量；正值向下偏移，负值向上偏移；默认 `0`
    /// - Note: 偏移基于内容垂直居中点；与 `tableHeaderView` 让位逻辑叠加
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat

    /// 各元素之间的垂直间距（pt）。
    ///
    /// - Parameter scrollView: 请求内容的滚动视图
    /// - Returns: 间距值；必须 > 0；默认 `11`
    /// - Note: 作用于 `image` / `title` / `description` / `button` 之间的相邻间隙
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat
}

/// `EmptyDataSetSource` 的默认实现，保证调用方仅需重写关心的方法。
public extension EmptyDataSetSource {

    /// 默认无标题
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? { nil }

    /// 默认无描述
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? { nil }

    /// 默认无插图
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? { nil }

    /// 默认不染色（按图片原始模式渲染）
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? { nil }

    /// 默认按图片与 `imageMaxWidth` 自动计算尺寸
    func imageSize(forEmptyDataSet scrollView: UIScrollView) -> CGSize? { nil }

    /// 默认插图最大宽度 `EmptyDataSetContent.defaultImageMaxWidth`（280pt）
    func imageMaxWidth(forEmptyDataSet scrollView: UIScrollView) -> CGFloat { EmptyDataSetContent.defaultImageMaxWidth }

    /// 默认无图片动画
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? { nil }

    /// 默认无按钮文字
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? { nil }

    /// 默认无按钮图片
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? { nil }

    /// 默认无按钮背景图
    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? { nil }

    /// 默认透明背景
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? { nil }

    /// 默认不使用自定义视图
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? { nil }

    /// 默认无垂直偏移
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat { 0 }

    /// 默认元素间距 11pt
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat { 11 }
}
