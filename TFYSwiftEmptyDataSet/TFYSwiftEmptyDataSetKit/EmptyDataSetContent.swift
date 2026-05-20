//
//  EmptyDataSetContent.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

/// 空态文案与样式的便捷构造器（支持深色模式语义色）
public enum EmptyDataSetContent {

    public static let defaultTitleFont = UIFont.systemFont(ofSize: 22, weight: .semibold)
    public static let defaultDetailFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    public static let defaultButtonFont = UIFont.systemFont(ofSize: 16, weight: .medium)

    public static var defaultTitleColor: UIColor { .secondaryLabel }
    public static var defaultDetailColor: UIColor { .tertiaryLabel }
    public static var defaultButtonColor: UIColor { .systemBlue }

    public static func title(
        _ text: String,
        font: UIFont = defaultTitleFont,
        color: UIColor = defaultTitleColor
    ) -> NSAttributedString {
        let scaledFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: font)
        return NSAttributedString(string: text, attributes: [.font: scaledFont, .foregroundColor: color])
    }

    public static func detail(
        _ text: String,
        font: UIFont = defaultDetailFont,
        color: UIColor = defaultDetailColor
    ) -> NSAttributedString {
        let scaledFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: font)
        return NSAttributedString(string: text, attributes: [.font: scaledFont, .foregroundColor: color])
    }

    public static func buttonTitle(
        _ text: String,
        font: UIFont = defaultButtonFont,
        color: UIColor = defaultButtonColor
    ) -> NSAttributedString {
        let scaledFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: font)
        return NSAttributedString(string: text, attributes: [.font: scaledFont, .foregroundColor: color])
    }

    /// 内置加载指示器视图，可用于 `customView(forEmptyDataSet:)`
    public static func makeLoadingView(
        style: UIActivityIndicatorView.Style = .large,
        text: String? = nil
    ) -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12

        let indicator = UIActivityIndicatorView(style: style)
        indicator.startAnimating()
        stack.addArrangedSubview(indicator)

        if let text, !text.isEmpty {
            let label = UILabel()
            label.text = text
            label.font = defaultDetailFont
            label.adjustsFontForContentSizeCategory = true
            label.textColor = defaultDetailColor
            label.textAlignment = .center
            label.numberOfLines = 0
            stack.addArrangedSubview(label)
        }

        return stack
    }
}

/// 配置式空态模型，适合不想单独实现 Source / Delegate 的轻量场景。
public struct EmptyDataSetConfiguration {
    public var title: NSAttributedString?
    public var detail: NSAttributedString?
    public var image: UIImage?
    public var imageTintColor: UIColor?
    public var imageAnimation: CAAnimation?
    public var buttonTitle: NSAttributedString?
    public var highlightedButtonTitle: NSAttributedString?
    public var buttonImage: UIImage?
    public var highlightedButtonImage: UIImage?
    public var buttonBackgroundImage: UIImage?
    public var highlightedButtonBackgroundImage: UIImage?
    public var backgroundColor: UIColor?
    public var customView: UIView?
    public var verticalOffset: CGFloat
    public var verticalSpace: CGFloat
    public var imageSize: CGSize
    public var contentInsets: UIEdgeInsets
    public var maximumContentWidth: CGFloat
    public var buttonContentInsets: NSDirectionalEdgeInsets
    public var accessibilityLabel: String?
    public var shouldFadeIn: Bool
    public var shouldAllowTouch: Bool
    public var shouldAllowScroll: Bool
    public var shouldAnimateImage: Bool
    public var shouldForceDisplay: Bool

    public init(
        title: NSAttributedString? = nil,
        detail: NSAttributedString? = nil,
        image: UIImage? = nil,
        imageTintColor: UIColor? = nil,
        imageAnimation: CAAnimation? = nil,
        buttonTitle: NSAttributedString? = nil,
        highlightedButtonTitle: NSAttributedString? = nil,
        buttonImage: UIImage? = nil,
        highlightedButtonImage: UIImage? = nil,
        buttonBackgroundImage: UIImage? = nil,
        highlightedButtonBackgroundImage: UIImage? = nil,
        backgroundColor: UIColor? = nil,
        customView: UIView? = nil,
        verticalOffset: CGFloat = 0,
        verticalSpace: CGFloat = 11,
        imageSize: CGSize = .zero,
        contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16),
        maximumContentWidth: CGFloat = 0,
        buttonContentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14),
        accessibilityLabel: String? = nil,
        shouldFadeIn: Bool = true,
        shouldAllowTouch: Bool = true,
        shouldAllowScroll: Bool = false,
        shouldAnimateImage: Bool = false,
        shouldForceDisplay: Bool = false
    ) {
        self.title = title
        self.detail = detail
        self.image = image
        self.imageTintColor = imageTintColor
        self.imageAnimation = imageAnimation
        self.buttonTitle = buttonTitle
        self.highlightedButtonTitle = highlightedButtonTitle
        self.buttonImage = buttonImage
        self.highlightedButtonImage = highlightedButtonImage
        self.buttonBackgroundImage = buttonBackgroundImage
        self.highlightedButtonBackgroundImage = highlightedButtonBackgroundImage
        self.backgroundColor = backgroundColor
        self.customView = customView
        self.verticalOffset = verticalOffset
        self.verticalSpace = verticalSpace
        self.imageSize = imageSize
        self.contentInsets = contentInsets
        self.maximumContentWidth = maximumContentWidth
        self.buttonContentInsets = buttonContentInsets
        self.accessibilityLabel = accessibilityLabel
        self.shouldFadeIn = shouldFadeIn
        self.shouldAllowTouch = shouldAllowTouch
        self.shouldAllowScroll = shouldAllowScroll
        self.shouldAnimateImage = shouldAnimateImage
        self.shouldForceDisplay = shouldForceDisplay
    }
}
