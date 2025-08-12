//
//  TFYSwiftEmptyDataSetView.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/22.
//

import UIKit
import Foundation

public class TFYSwiftEmptyDataSetView: UIView {

    internal lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.clear
        contentView.isUserInteractionEnabled = true
        contentView.alpha = 0
        return contentView
    }()
    
    internal lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.accessibilityIdentifier = "空白背景图像"
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    internal lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = UIColor.clear
        
        titleLabel.font = UIFont.systemFont(ofSize: 27.0)
        titleLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.accessibilityIdentifier = "空集标题"
        self.contentView.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.backgroundColor = UIColor.clear
        
        detailLabel.font = UIFont.systemFont(ofSize: 17.0)
        detailLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        detailLabel.textAlignment = .center
        detailLabel.lineBreakMode = .byWordWrapping
        detailLabel.numberOfLines = 0
        detailLabel.accessibilityIdentifier = "设置详细信息标签为空"
        self.contentView.addSubview(detailLabel)
        return detailLabel
    }()
    
    internal lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.accessibilityIdentifier = "空集按钮"
        self.contentView.addSubview(button)
        return button
    }()

    private var canShowImage: Bool {
        return self.imageView.image != nil
    }
    
    private var canShowTitle: Bool {
        if let attributedText = self.titleLabel.attributedText {
            return attributedText.length > 0
        }
        return false
    }
    
    private var canShowDetail: Bool {
        if let attributedText = self.detailLabel.attributedText {
            return attributedText.length > 0
        }
        return false
    }
    
    private var canShowButton: Bool {
        if let attributedTitle = self.button.attributedTitle(for: .normal) {
            return attributedTitle.length > 0
        } else if let _ = self.button.image(for: .normal) {
            return true
        }
        
        return false
    }
    
    
    internal var customView: UIView? {
        willSet {
            if let customView = self.customView {
                customView.removeFromSuperview()
            }
        }
        didSet {
            if let customView = self.customView {
                customView.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(customView)
            }
        }
    }
    
    internal var fadeInOnDisplay = false
    internal var verticalOffset: CGFloat = 0
    internal var verticalSpace: CGFloat = 11
    
    internal var didTapContentViewHandle: (() -> Void)?
    internal var didTapDataButtonHandle: (() -> Void)?
    internal var willAppearHandle: (() -> Void)?
    internal var didAppearHandle: (() -> Void)?
    internal var willDisappearHandle: (() -> Void)?
    internal var didDisappearHandle: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToWindow() {
        if let superviewBounds = superview?.bounds {
            frame = CGRect(x: 0, y: 0, width: superviewBounds.width, height: superviewBounds.height)
        }
        if fadeInOnDisplay {
            UIView.animate(withDuration: 0.25) {
                self.contentView.alpha = 1
            }
        } else {
            self.contentView.alpha = 1
        }
    }
    
    // MARK: - Action Methods
    internal func removeAllConstraints() {
        removeConstraints(constraints)
        self.contentView.removeConstraints(self.contentView.constraints)
    }
    
    internal func prepareForReuse() {
        self.titleLabel.text = nil
        self.detailLabel.text = nil
        self.imageView.image = nil
        self.button.setImage(nil, for: .normal)
        self.button.setImage(nil, for: .highlighted)
        self.button.setAttributedTitle(nil, for: .normal)
        self.button.setAttributedTitle(nil, for: .highlighted)
        self.button.setBackgroundImage(nil, for: .normal)
        self.button.setBackgroundImage(nil, for: .highlighted)
        self.customView = nil
        
        self.removeAllConstraints()
    }
    
    internal func setupConstraints() {
        
        let centerXConstraint = NSLayoutConstraint(item: self.contentView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: self.contentView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        self.addConstraints([centerXConstraint,centerYConstraint])
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]", options: [], metrics: nil, views: ["contentView": self.contentView]))
        /// 当自定义偏移量可用时，我们调整垂直约束的常量
        if self.verticalOffset != 0 && constraints.count > 0 {
            centerYConstraint.constant = self.verticalOffset
        }
       
        if let customView = self.customView {
            
            let centerXConstraint = NSLayoutConstraint(item: customView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            let centerYConstraint = NSLayoutConstraint(item: customView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            
            let customViewHeight = customView.frame.height
            let customViewWidth = customView.frame.width
            var heightConstarint: NSLayoutConstraint!
            var widthConstarint: NSLayoutConstraint!
            
            if(customViewHeight == 0) {
                heightConstarint = NSLayoutConstraint(item: customView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: self, attribute: .height, multiplier: 1, constant: 0.0)
            } else {
                heightConstarint = NSLayoutConstraint(item: customView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: customViewHeight)
            }
            if(customViewWidth == 0) {
                widthConstarint = NSLayoutConstraint(item: customView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self, attribute: .width, multiplier: 1, constant: 0.0)
            } else {
                widthConstarint = NSLayoutConstraint(item: customView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: customViewWidth)
            }
            /// 当自定义偏移量可用时，我们调整垂直约束的常量
            if self.verticalOffset != 0 {
                centerYConstraint.constant = self.verticalOffset
            }
            self.addConstraints([centerXConstraint, centerYConstraint])
            self.addConstraints([heightConstarint, widthConstarint])
            
        } else {
            
            let width = frame.width > 0 ? frame.width : UIScreen.main.bounds.width
            let padding = roundf(Float(width/16.0))
            let verticalSpace = self.verticalSpace
            
            var subviewStrings: [String] = []
            var views: [String: UIView] = [:]
            let metrics = ["padding": padding]
            
            var verticalFormat = String()
            
            /// 分配图像视图的水平约束
            if self.canShowImage {
                self.imageView.isHidden = false
                
                subviewStrings.append("imageView")
                views[subviewStrings.last!] = self.imageView
                
                self.contentView.addConstraint(NSLayoutConstraint.init(item: self.imageView, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            } else {
                self.imageView.isHidden = true
            }
            
            /// 分配标题标签的水平约束
            if self.canShowTitle {
                self.titleLabel.isHidden = false
                
                subviewStrings.append("titleLabel")
                views[subviewStrings.last!] = self.titleLabel
                
                self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[titleLabel(>=0)]-(padding)-|", options: [], metrics: metrics, views: views))
            } else {
                self.titleLabel.isHidden = true
            }
            
            /// 分配细节标签的水平约束
            if self.canShowDetail {
                self.detailLabel.isHidden = false
                
                subviewStrings.append("detailLabel")
                views[subviewStrings.last!] = self.detailLabel

                self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[detailLabel(>=0)]-(padding)-|", options: [], metrics: metrics, views: views))
            } else {
                self.detailLabel.isHidden = true
            }
            
            /// 分配按钮的水平约束
            if self.canShowButton {
                self.button.isHidden = false
                
                subviewStrings.append("button")
                views[subviewStrings.last!] = self.button
                
                self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[button(>=0)]-(padding)-|", options: [], metrics: metrics, views: views))
            } else {
                self.button.isHidden = true
            }
            
            // 为垂直约束构建动态字符串格式，在每个元素之间添加空白。默认是11分。
            for i in 0 ..< subviewStrings.count {
                
                let string = subviewStrings[i]
                
                verticalFormat += "[\(string)]"
                
                if i < subviewStrings.count - 1 {
                    
                    verticalFormat += "-(\(verticalSpace))-"
                }
            }
            
            // 将垂直约束分配给内容视图
            if !verticalFormat.isEmpty {
                self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|\(verticalFormat)|", options: [], metrics: metrics, views: views))
            }
            
        }
    }
}


extension TFYSwiftEmptyDataSetView {
    
    /// 向数据源请求数据集的标题。
    /// 如果没有设置任何属性，则数据集默认使用固定的字体样式。如果你想要不同的字体样式，返回一个带属性的字符串。
    @discardableResult
    public func titleLabelString(_ attributedString: NSAttributedString?) -> Self {
        self.titleLabel.attributedText = attributedString
        return self
    }
    
    /// 向数据源请求数据集的描述。
    /// 如果没有设置任何属性，则数据集默认使用固定的字体样式。如果你想要不同的字体样式，返回一个带属性的字符串。
    @discardableResult
    public func detailLabelString(_ attributedString: NSAttributedString?) -> Self {
        self.detailLabel.attributedText = attributedString
        return self
    }
    
    /// 向数据源请求数据集的映像。
    @discardableResult
    public func image(_ image: UIImage?) -> Self {
        self.imageView.image = image
        return self
    }
    
    /// 向数据源请求图像数据集的色调颜色。默认是零。
    @discardableResult
    public func imageTintColor(_ imageTintColor: UIColor?) -> Self {
        self.imageView.tintColor = imageTintColor
        return self
    }
    
    /// 向数据源请求数据集的图像动画。
    @discardableResult
    public func imageAnimation(_ imageAnimation: CAAnimation?) -> Self {
        if let ani = imageAnimation {
            self.imageView.layer.add(ani, forKey: nil)
        }
        return self
    }
    
    /// 向数据源请求要用于指定按钮状态的标题。
    /// 如果没有设置任何属性，则数据集默认使用固定的字体样式。如果你想要不同的字体样式，返回一个带属性的字符串。
    @discardableResult
    public func buttonTitle(_ buttonTitle: NSAttributedString?, for state: UIControl.State) -> Self {
        self.button.setAttributedTitle(buttonTitle, for: state)
        return self
    }
    
    /// 请求数据源提供用于指定按钮状态的图像。
    /// 这个方法将覆盖buttonTitleForEmptyDataSet:forState:并且只显示图像，不包含任何文本。
    @discardableResult
    public func buttonImage(_ buttonImage: UIImage?, for state: UIControl.State) -> Self {
        self.button.setImage(buttonImage, for: state)
        return self
    }
    
    /// 向数据源请求用于指定按钮状态的背景图像。
    /// 这个调用没有默认的样式。
    @discardableResult
    public func buttonBackgroundImage(_ buttonBackgroundImage: UIImage?, for state: UIControl.State) -> Self {
        self.button.setBackgroundImage(buttonBackgroundImage, for: state)
        return self
    }
    
    /// 向数据源请求数据集的背景颜色。默认是清晰的颜色。
    @discardableResult
    public func dataSetBackgroundColor(_ backgroundColor: UIColor?) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }
    
    /// 请求数据源显示一个自定义视图，而不是默认视图，如标签、imageview和按钮。默认是零。
    /// 使用此方法可以显示用于加载反馈的活动视图指示器，或用于完整的自定义空数据集。
    /// 返回自定义视图将忽略-offsetForEmptyDataSet和-spaceHeightForEmptyDataSet配置。
    @discardableResult
    public func customView(_ customView: UIView?) -> Self {
        self.customView = customView
        return self
    }
    
    /// 向数据源请求内容垂直对齐的偏移量。默认值为0。
    @discardableResult
    public func verticalOffset(_ offset: CGFloat) -> Self {
        self.verticalOffset = offset
        return self
    }
    
    /// 向数据源请求元素之间的垂直空间。默认是11分。
    @discardableResult
    public func verticalSpace(_ space: CGFloat) -> Self {
        self.verticalSpace = space
        return self
    }
    
    //MARK: - Delegate & Events
    /// 询问委托，以知道空数据集在显示时是否应该淡入。默认是正确的。
    @discardableResult
    public func shouldFadeIn(_ bool: Bool) -> Self {
        self.fadeInOnDisplay = bool
        return self
    }
    
    /// 询问委托，以知道当项的数量大于0时是否仍应显示空数据集。默认是假的。
    @discardableResult
    public func shouldBeForcedToDisplay(_ bool: Bool) -> Self {
        isHidden = !bool
        return self
    }
    
    /// 询问委托是否应该呈现和显示空数据集。默认是正确的。
    @discardableResult
    public func shouldDisplay(_ bool: Bool) -> Self {
        if let superview = self.superview as? UIScrollView {
            isHidden = !(bool && superview.itemsCount == 0)
        }
        return self
    }
    
    /// 向委托请求触摸许可。默认是正确的。
    @discardableResult
    public func isTouchAllowed(_ bool: Bool) -> Self {
        isUserInteractionEnabled = bool
        return self
    }
    
    /// 向委托请求滚动许可。默认是假的。
    @discardableResult
    public func isScrollAllowed(_ bool: Bool) -> Self {
        if let superview = superview as? UIScrollView {
            superview.isScrollEnabled = bool
        }
        return self
    }
    
    /// 向委托请求图像视图动画权限。默认是假的。
    /// 确保从imageAnimationForEmptyDataSet返回一个有效的CAAnimation对象:
    @discardableResult
    public func isImageViewAnimateAllowed(_ bool: Bool) -> Self {
        if !bool {
            self.imageView.layer.removeAllAnimations()
        }
        return self
    }
    
    /// 告诉委托已单击空数据集视图。
    /// 使用此方法可以resignFirstResponder的文本框或搜索栏。
    @discardableResult
    public func didTapContentView(_ closure: @escaping () -> (Void)) -> Self {
        self.didTapContentViewHandle = closure
        return self
    }
    
    /// 告诉委托操作按钮已被点击。
    @discardableResult
    public func didTapDataButton(_ closure: @escaping () -> (Void)) -> Self {
        self.didTapDataButtonHandle = closure
        return self
    }
    
    /// 告诉委托将出现空数据集。
    @discardableResult
    public func willAppear(_ closure: @escaping () -> (Void)) -> Self {
        self.willAppearHandle = closure
        return self
    }
    
    /// 告诉委托已出现空数据集。
    @discardableResult
    public func didAppear(_ closure: @escaping () -> (Void)) -> Self {
        self.didAppearHandle = closure
        return self
    }
    
    /// 告诉委托空数据集将消失。
    @discardableResult
    public func willDisappear(_ closure: @escaping () -> (Void)) -> Self {
        self.willDisappearHandle = closure
        return self
    }
    
    /// 告诉委托空数据集已消失。
    @discardableResult
    public func didDisappear(_ closure: @escaping () -> (Void)) -> Self {
        self.didDisappearHandle = closure
        return self
    }
}
