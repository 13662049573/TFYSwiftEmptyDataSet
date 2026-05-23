//
//  TFYSwiftEmptyDataSetView.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

public final class TFYSwiftEmptyDataSetView: UIView {

    internal lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.alpha = 1
        return view
    }()

    internal lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.accessibilityIdentifier = "emptyDataSet.imageView"
        contentView.addSubview(imageView)
        return imageView
    }()

    internal lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = EmptyDataSetContent.defaultTitleFont
        label.textColor = EmptyDataSetContent.defaultTitleColor
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.accessibilityIdentifier = "emptyDataSet.titleLabel"
        contentView.addSubview(label)
        return label
    }()

    internal lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = EmptyDataSetContent.defaultDetailFont
        label.textColor = EmptyDataSetContent.defaultDetailColor
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.accessibilityIdentifier = "emptyDataSet.detailLabel"
        contentView.addSubview(label)
        return label
    }()

    internal lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.accessibilityIdentifier = "emptyDataSet.button"
        contentView.addSubview(button)
        return button
    }()

    private var canShowImage: Bool { imageView.image != nil }

    private var canShowTitle: Bool {
        guard let text = titleLabel.attributedText else { return false }
        return text.length > 0
    }

    private var canShowDetail: Bool {
        guard let text = detailLabel.attributedText else { return false }
        return text.length > 0
    }

    private var canShowButton: Bool {
        if let title = button.attributedTitle(for: .normal), title.length > 0 {
            return true
        }
        return button.image(for: .normal) != nil
    }

    internal var customView: UIView? {
        willSet {
            customView?.removeFromSuperview()
        }
        didSet {
            guard let customView else { return }
            customView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(customView)
        }
    }

    internal var fadeInOnDisplay = false
    internal var verticalOffset: CGFloat = 0
    internal var verticalSpace: CGFloat = 11
    internal var preferredMaxImageWidth: CGFloat = EmptyDataSetContent.defaultImageMaxWidth
    internal var customImageSize: CGSize?

    internal var didTapContentViewHandle: (() -> Void)?
    internal var didTapDataButtonHandle: (() -> Void)?
    internal var willAppearHandle: (() -> Void)?
    internal var didAppearHandle: (() -> Void)?
    internal var willDisappearHandle: (() -> Void)?
    internal var didDisappearHandle: (() -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        isAccessibilityElement = false
        accessibilityViewIsModal = false
        addSubview(contentView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()
    }

    internal func removeAllConstraints() {
        removeConstraints(constraints)
        contentView.removeConstraints(contentView.constraints)
        customView?.removeConstraints(customView?.constraints ?? [])
    }

    internal func prepareForReuse() {
        titleLabel.attributedText = nil
        detailLabel.attributedText = nil
        imageView.image = nil
        imageView.layer.removeAllAnimations()
        button.setImage(nil, for: .normal)
        button.setImage(nil, for: .highlighted)
        button.setAttributedTitle(nil, for: .normal)
        button.setAttributedTitle(nil, for: .highlighted)
        button.setBackgroundImage(nil, for: .normal)
        button.setBackgroundImage(nil, for: .highlighted)
        customView = nil
        removeAllConstraints()
    }

    /// 仅在首次显示（从隐藏到可见的转场）时执行淡入，避免后续重载触发闪烁
    /// - Parameter animated: 是否执行淡入动画
    internal func applyContentVisibility(animated: Bool) {
        contentView.layer.removeAnimation(forKey: "emptyDataSet.fadeIn")
        if animated && fadeInOnDisplay {
            contentView.alpha = 0
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState]
            ) {
                self.contentView.alpha = 1
            }
        } else {
            contentView.alpha = 1
        }
    }

    internal func setupConstraints() {
        let centerX = contentView.centerXAnchor.constraint(equalTo: centerXAnchor)
        let centerY = contentView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: verticalOffset)
        NSLayoutConstraint.activate([
            centerX,
            centerY,
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        if let customView {
            NSLayoutConstraint.activate([
                customView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                customView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: verticalOffset)
            ])
            if customView.bounds.width > 0 {
                customView.widthAnchor.constraint(equalToConstant: customView.bounds.width).isActive = true
            } else {
                customView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor).isActive = true
            }
            if customView.bounds.height > 0 {
                customView.heightAnchor.constraint(equalToConstant: customView.bounds.height).isActive = true
            } else {
                customView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor).isActive = true
            }
            return
        }

        let width = bounds.width > 0 ? bounds.width : UIScreen.main.bounds.width
        let padding = max(16, width / 16)
        var previousAnchor: NSLayoutYAxisAnchor = contentView.topAnchor

        func pinHorizontally(_ view: UIView) {
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: padding),
                view.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -padding),
                view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
        }

        if canShowImage, let image = imageView.image {
            imageView.isHidden = false
            let displaySize: CGSize
            if let customImageSize, customImageSize.width > 0, customImageSize.height > 0 {
                displaySize = customImageSize
            } else {
                displaySize = EmptyDataSetContent.preferredImageDisplaySize(
                    for: image,
                    containerWidth: width,
                    maxWidth: preferredMaxImageWidth
                )
            }
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: previousAnchor),
                imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: displaySize.width),
                imageView.heightAnchor.constraint(equalToConstant: displaySize.height)
            ])
            previousAnchor = imageView.bottomAnchor
        } else {
            imageView.isHidden = true
        }

        if canShowTitle {
            titleLabel.isHidden = false
            if previousAnchor === contentView.topAnchor {
                titleLabel.topAnchor.constraint(equalTo: previousAnchor).isActive = true
            } else {
                titleLabel.topAnchor.constraint(equalTo: previousAnchor, constant: verticalSpace).isActive = true
            }
            pinHorizontally(titleLabel)
            previousAnchor = titleLabel.bottomAnchor
        } else {
            titleLabel.isHidden = true
        }

        if canShowDetail {
            detailLabel.isHidden = false
            if previousAnchor === contentView.topAnchor {
                detailLabel.topAnchor.constraint(equalTo: previousAnchor).isActive = true
            } else {
                detailLabel.topAnchor.constraint(equalTo: previousAnchor, constant: verticalSpace).isActive = true
            }
            pinHorizontally(detailLabel)
            previousAnchor = detailLabel.bottomAnchor
        } else {
            detailLabel.isHidden = true
        }

        if canShowButton {
            button.isHidden = false
            if previousAnchor === contentView.topAnchor {
                button.topAnchor.constraint(equalTo: previousAnchor).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: previousAnchor, constant: verticalSpace).isActive = true
            }
            pinHorizontally(button)
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        } else {
            button.isHidden = true
            if previousAnchor !== contentView.topAnchor {
                previousAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            }
        }
    }
}

// MARK: - Fluent configuration

extension TFYSwiftEmptyDataSetView {

    @discardableResult
    public func titleLabelString(_ attributedString: NSAttributedString?) -> Self {
        titleLabel.attributedText = attributedString
        return self
    }

    @discardableResult
    public func detailLabelString(_ attributedString: NSAttributedString?) -> Self {
        detailLabel.attributedText = attributedString
        return self
    }

    @discardableResult
    public func image(_ image: UIImage?) -> Self {
        imageView.image = image
        return self
    }

    @discardableResult
    public func imageMaxWidth(_ width: CGFloat) -> Self {
        preferredMaxImageWidth = width
        return self
    }

    @discardableResult
    public func imageSize(_ size: CGSize?) -> Self {
        customImageSize = size
        return self
    }

    @discardableResult
    public func imageTintColor(_ color: UIColor?) -> Self {
        imageView.tintColor = color
        if let image = imageView.image, let color {
            imageView.image = image.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
        }
        return self
    }

    @discardableResult
    public func imageAnimation(_ animation: CAAnimation?) -> Self {
        imageView.layer.removeAllAnimations()
        if let animation {
            imageView.layer.add(animation, forKey: "emptyDataSet.imageAnimation")
        }
        return self
    }

    @discardableResult
    public func buttonTitle(_ title: NSAttributedString?, for state: UIControl.State) -> Self {
        button.setAttributedTitle(title, for: state)
        return self
    }

    @discardableResult
    public func buttonImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        button.setImage(image, for: state)
        return self
    }

    @discardableResult
    public func buttonBackgroundImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        button.setBackgroundImage(image, for: state)
        return self
    }

    @discardableResult
    public func dataSetBackgroundColor(_ color: UIColor?) -> Self {
        backgroundColor = color
        return self
    }

    @discardableResult
    public func customView(_ view: UIView?) -> Self {
        customView = view
        return self
    }

    @discardableResult
    public func verticalOffset(_ offset: CGFloat) -> Self {
        verticalOffset = offset
        return self
    }

    @discardableResult
    public func verticalSpace(_ space: CGFloat) -> Self {
        verticalSpace = space
        return self
    }

    @discardableResult
    public func shouldFadeIn(_ enabled: Bool) -> Self {
        fadeInOnDisplay = enabled
        return self
    }

    @discardableResult
    public func isTouchAllowed(_ allowed: Bool) -> Self {
        isUserInteractionEnabled = allowed
        return self
    }

    @discardableResult
    public func isScrollAllowed(_ allowed: Bool) -> Self {
        if let scrollView = superview as? UIScrollView {
            scrollView.isScrollEnabled = allowed
        }
        return self
    }

    @discardableResult
    public func isImageViewAnimateAllowed(_ allowed: Bool) -> Self {
        if !allowed {
            imageView.layer.removeAllAnimations()
        }
        return self
    }

    @discardableResult
    public func didTapContentView(_ closure: @escaping () -> Void) -> Self {
        didTapContentViewHandle = closure
        return self
    }

    @discardableResult
    public func didTapDataButton(_ closure: @escaping () -> Void) -> Self {
        didTapDataButtonHandle = closure
        return self
    }

    @discardableResult
    public func willAppear(_ closure: @escaping () -> Void) -> Self {
        willAppearHandle = closure
        return self
    }

    @discardableResult
    public func didAppear(_ closure: @escaping () -> Void) -> Self {
        didAppearHandle = closure
        return self
    }

    @discardableResult
    public func willDisappear(_ closure: @escaping () -> Void) -> Self {
        willDisappearHandle = closure
        return self
    }

    @discardableResult
    public func didDisappear(_ closure: @escaping () -> Void) -> Self {
        didDisappearHandle = closure
        return self
    }
}
