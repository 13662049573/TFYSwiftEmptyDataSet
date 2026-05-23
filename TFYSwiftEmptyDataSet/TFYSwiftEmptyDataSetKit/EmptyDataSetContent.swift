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

    /// 空态插图默认最大宽度（pt）
    public static let defaultImageMaxWidth: CGFloat = 280
    /// 空态插图默认最大高度（pt）
    public static let defaultImageMaxHeight: CGFloat = 280

    public static var defaultTitleColor: UIColor { .secondaryLabel }
    public static var defaultDetailColor: UIColor { .tertiaryLabel }
    public static var defaultButtonColor: UIColor { .systemBlue }

    public static func title(
        _ text: String,
        font: UIFont = defaultTitleFont,
        color: UIColor = defaultTitleColor
    ) -> NSAttributedString {
        NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }

    public static func detail(
        _ text: String,
        font: UIFont = defaultDetailFont,
        color: UIColor = defaultDetailColor
    ) -> NSAttributedString {
        NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }

    public static func buttonTitle(
        _ text: String,
        font: UIFont = defaultButtonFont,
        color: UIColor = defaultButtonColor
    ) -> NSAttributedString {
        NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
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
            label.textColor = defaultDetailColor
            label.textAlignment = .center
            label.numberOfLines = 0
            stack.addArrangedSubview(label)
        }

        return stack
    }

    /// 根据图片与容器计算合适的展示尺寸（兼容 @3x 资源导出偏小的情况）
    public static func preferredImageDisplaySize(
        for image: UIImage,
        containerWidth: CGFloat,
        maxWidth: CGFloat? = nil,
        maxHeight: CGFloat = defaultImageMaxHeight
    ) -> CGSize {
        let horizontalPadding = max(32, containerWidth / 8)
        let capWidth = maxWidth ?? min(max(containerWidth - horizontalPadding, 120), defaultImageMaxWidth)
        guard image.size.width > 0, image.size.height > 0 else {
            return CGSize(width: capWidth, height: capWidth)
        }

        let aspect = image.size.width / image.size.height
        var width = min(capWidth, image.size.width)
        // 逻辑尺寸明显小于上限时（如 @3x 图只有 400px），放大到合理展示宽度
        if width < capWidth * 0.9 {
            width = capWidth
        }
        var height = width / aspect
        if height > maxHeight {
            height = maxHeight
            width = height * aspect
        }
        return CGSize(width: width, height: height)
    }
}
