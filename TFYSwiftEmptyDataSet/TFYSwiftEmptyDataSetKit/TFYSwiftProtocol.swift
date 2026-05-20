//
//  TFYSwiftProtocol.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

// MARK: - EmptyDataSetDelegate

/// 空数据集行为回调。仅需实现关心的方法，其余使用 extension 中的默认值。
public protocol EmptyDataSetDelegate: AnyObject {

    func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool
    func emptyDataSetShouldBeForcedToDisplay(_ scrollView: UIScrollView) -> Bool
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool

    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView)
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton)

    func emptyDataSetWillAppear(_ scrollView: UIScrollView)
    func emptyDataSetDidAppear(_ scrollView: UIScrollView)
    func emptyDataSetWillDisappear(_ scrollView: UIScrollView)
    func emptyDataSetDidDisappear(_ scrollView: UIScrollView)
}

public extension EmptyDataSetDelegate {
    func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool { true }
    func emptyDataSetShouldBeForcedToDisplay(_ scrollView: UIScrollView) -> Bool { false }
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool { true }
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool { true }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { false }
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool { false }

    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {}
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {}

    func emptyDataSetWillAppear(_ scrollView: UIScrollView) {}
    func emptyDataSetDidAppear(_ scrollView: UIScrollView) {}
    func emptyDataSetWillDisappear(_ scrollView: UIScrollView) {}
    func emptyDataSetDidDisappear(_ scrollView: UIScrollView) {}
}

// MARK: - EmptyDataSetSource

/// 空数据集内容数据源。仅需实现关心的方法，其余使用 extension 中的默认值。
public protocol EmptyDataSetSource: AnyObject {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage?
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor?
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation?

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString?
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage?
    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage?

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor?
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView?
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat
    func imageSize(forEmptyDataSet scrollView: UIScrollView) -> CGSize
    func contentInsets(forEmptyDataSet scrollView: UIScrollView) -> UIEdgeInsets
    func maximumContentWidth(forEmptyDataSet scrollView: UIScrollView) -> CGFloat
    func buttonContentInsets(forEmptyDataSet scrollView: UIScrollView) -> NSDirectionalEdgeInsets
    func accessibilityLabel(forEmptyDataSet scrollView: UIScrollView) -> String?
}

public extension EmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? { nil }
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? { nil }
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? { nil }
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? { nil }
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? { nil }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? { nil }
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? { nil }
    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? { nil }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? { nil }
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? { nil }
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat { 0 }
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat { 11 }
    func imageSize(forEmptyDataSet scrollView: UIScrollView) -> CGSize { .zero }
    func contentInsets(forEmptyDataSet scrollView: UIScrollView) -> UIEdgeInsets { UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) }
    func maximumContentWidth(forEmptyDataSet scrollView: UIScrollView) -> CGFloat { 0 }
    func buttonContentInsets(forEmptyDataSet scrollView: UIScrollView) -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14)
    }
    func accessibilityLabel(forEmptyDataSet scrollView: UIScrollView) -> String? { nil }
}
