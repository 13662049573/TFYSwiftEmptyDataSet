//
//  UIScrollView+EmptyDataSet.swift
//  TFYSwiftEmptyDataSet
//
//  Created by 田风有 on 2021/6/22.
//

import Foundation
import UIKit

class WeakObjectContainer: NSObject {
    weak var weakObject: AnyObject?
    
    init(with weakObject: Any?) {
        super.init()
        self.weakObject = weakObject as AnyObject?
    }
}

private var kEmptyDataSetSource =           "emptyDataSetSource"
private var kEmptyDataSetDelegate =         "emptyDataSetDelegate"
private var kEmptyDataSetView =             "emptyDataSetView"
private var kConfigureEmptyDataSetView =    "configureEmptyDataSetView"

extension UIScrollView: @retroactive UIGestureRecognizerDelegate {
    
    private var configureEmptyDataSetView: ((TFYSwiftEmptyDataSetView) -> Void)? {
        get {
            return objc_getAssociatedObject(self, (kConfigureEmptyDataSetView)) as? (TFYSwiftEmptyDataSetView) -> Void
        }
        set {
            objc_setAssociatedObject(self, (kConfigureEmptyDataSetView), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            UIScrollView.swizzleReloadData
            if self is UITableView {
                UIScrollView.swizzleEndUpdates
            }
        }
    }
    
    //MARK: - Public Property
    public var emptyDataSetSource: EmptyDataSetSource? {
        get {
            let container = objc_getAssociatedObject(self, (kEmptyDataSetSource)) as? WeakObjectContainer
            return container?.weakObject as? EmptyDataSetSource
        }
        set {
            if newValue == nil {
                self.invalidate()
            }
            objc_setAssociatedObject(self, (kEmptyDataSetSource), WeakObjectContainer(with: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            UIScrollView.swizzleReloadData
            if self is UITableView {
                UIScrollView.swizzleEndUpdates
            }
        }
    }
    
    public var emptyDataSetDelegate: EmptyDataSetDelegate? {
        get {
            let container = objc_getAssociatedObject(self, (kEmptyDataSetDelegate)) as? WeakObjectContainer
            return container?.weakObject as? EmptyDataSetDelegate
        }
        set {
            if newValue == nil {
                self.invalidate()
            }
            objc_setAssociatedObject(self, (kEmptyDataSetDelegate), WeakObjectContainer(with: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var isEmptyDataSetVisible: Bool {
        if let view = objc_getAssociatedObject(self, (kEmptyDataSetView)) as? TFYSwiftEmptyDataSetView {
            return !view.isHidden
        }
        return false
    }
    
    //MARK: - privateProperty
    public func emptyDataSetView(_ closure: @escaping (TFYSwiftEmptyDataSetView) -> Void) {
        configureEmptyDataSetView = closure
    }
    
    private var emptyDataSetView: TFYSwiftEmptyDataSetView? {
        get {
            if let view = objc_getAssociatedObject(self,(kEmptyDataSetView)) as? TFYSwiftEmptyDataSetView {
                return view
            } else {
                let view = TFYSwiftEmptyDataSetView.init(frame: frame)
                view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                view.isHidden = true
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapContentView(_:)))
                tapGesture.delegate = self
                view.addGestureRecognizer(tapGesture)
                view.button.addTarget(self, action: #selector(didTapDataButton(_:)), for: .touchUpInside)

                objc_setAssociatedObject(self,(kEmptyDataSetView), view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return view
            }
        }
        set {
            objc_setAssociatedObject(self,(kEmptyDataSetView), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    internal var itemsCount: Int {
        var items = 0
        
        // UITableView support
        if let tableView = self as? UITableView {
            var sections = 1
            
            if let dataSource = tableView.dataSource {
                if dataSource.responds(to: #selector(UITableViewDataSource.numberOfSections(in:))) {
                    sections = dataSource.numberOfSections!(in: tableView)
                }
                if dataSource.responds(to: #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))) {
                    for i in 0 ..< sections {
                        items += dataSource.tableView(tableView, numberOfRowsInSection: i)
                    }
                }
            }
        } else if let collectionView = self as? UICollectionView {
            var sections = 1
            
            if let dataSource = collectionView.dataSource {
                if dataSource.responds(to: #selector(UICollectionViewDataSource.numberOfSections(in:))) {
                    sections = dataSource.numberOfSections!(in: collectionView)
                }
                if dataSource.responds(to: #selector(UICollectionViewDataSource.collectionView(_:numberOfItemsInSection:))) {
                    for i in 0 ..< sections {
                        items += dataSource.collectionView(collectionView, numberOfItemsInSection: i)
                    }
                }
            }
        }
        return items
    }
    
    //MARK: - Data Source Getters
    private var titleLabelString: NSAttributedString? {
        return emptyDataSetSource?.title?(forEmptyDataSet: self)
    }
    
    private var detailLabelString: NSAttributedString? {
        return emptyDataSetSource?.description?(forEmptyDataSet: self)
    }
    
    private var image: UIImage? {
        return emptyDataSetSource?.image?(forEmptyDataSet: self)
    }
    
    private var imageAnimation: CAAnimation? {
        return emptyDataSetSource?.imageAnimation?(forEmptyDataSet: self)
    }
    
    private var imageTintColor: UIColor? {
        return emptyDataSetSource?.imageTintColor?(forEmptyDataSet: self)
    }
    
    private func buttonTitle(for state: UIControl.State) -> NSAttributedString? {
        return emptyDataSetSource?.buttonTitle?(forEmptyDataSet: self, for: state)
    }
    
    private func buttonImage(for state: UIControl.State) -> UIImage? {
        return emptyDataSetSource?.buttonImage?(forEmptyDataSet: self, for: state)
    }
    
    private func buttonBackgroundImage(for state: UIControl.State) -> UIImage? {
        return emptyDataSetSource?.buttonBackgroundImage?(forEmptyDataSet: self, for: state)
    }
    
    private var dataSetBackgroundColor: UIColor? {
        return emptyDataSetSource?.backgroundColor?(forEmptyDataSet: self)
    }
    
    private var customView: UIView? {
        return emptyDataSetSource?.customView?(forEmptyDataSet: self)
    }
    
    private var verticalOffset: CGFloat {
        return emptyDataSetSource?.verticalOffset?(forEmptyDataSet: self) ?? 0.0
    }
    
    private var verticalSpace: CGFloat {
        return emptyDataSetSource?.spaceHeight?(forEmptyDataSet: self) ?? 0.0
    }
    
    //MARK: - Delegate Getters & Events (Private)
    
    private var shouldFadeIn: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldFadeIn?(self) ?? true
    }
    
    private var shouldDisplay: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldDisplay?(self) ?? true
    }
    
    private var shouldBeForcedToDisplay: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldBeForcedToDisplay?(self) ?? false
    }
    
    private var isTouchAllowed: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldAllowTouch?(self) ?? true
    }
    
    private var isScrollAllowed: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldAllowScroll?(self) ?? false
    }
    
    private var isImageViewAnimateAllowed: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldAnimateImageView?(self) ?? true
    }
    
    private func willAppear() {
        emptyDataSetDelegate?.emptyDataSetWillAppear?(self)
        emptyDataSetView?.willAppearHandle?()
    }
    
    private func didAppear() {
        emptyDataSetDelegate?.emptyDataSetDidAppear?(self)
        emptyDataSetView?.didAppearHandle?()
    }
    
    private func willDisappear() {
        emptyDataSetDelegate?.emptyDataSetWillDisappear?(self)
        emptyDataSetView?.willDisappearHandle?()
    }
    
    private func didDisappear() {
        emptyDataSetDelegate?.emptyDataSetDidDisappear?(self)
        emptyDataSetView?.didDisappearHandle?()
    }
    
    @objc private func didTapContentView(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        emptyDataSetDelegate?.emptyDataSet?(self, didTapView: view)
        emptyDataSetView?.didTapContentViewHandle?()
    }
    
    @objc private func didTapDataButton(_ sender: UIButton) {
        emptyDataSetDelegate?.emptyDataSet?(self, didTapButton: sender)
        emptyDataSetView?.didTapDataButtonHandle?()
    }
    
    //MARK: - Reload APIs (Public)
    public func reloadEmptyDataSet() {
        guard (emptyDataSetSource != nil || configureEmptyDataSetView != nil) else {
            return
        }
        
        if (shouldDisplay && itemsCount == 0) || shouldBeForcedToDisplay {
            // 通知将出现空数据集视图
            willAppear()
            
            if let view = emptyDataSetView {
                
                // 配置空数据集淡出显示
                view.fadeInOnDisplay = shouldFadeIn
                
                if view.superview == nil {
                    // 将视图发送到后面，以防出现页眉和/或页脚，以及sectionHeaders或任何其他内容
                    if (self is UITableView) || (self is UICollectionView) || (subviews.count > 1) {
                        insertSubview(view, at: 0)
                    } else {
                        addSubview(view)
                    }
                }
                
                // 移除视图重置视图及其约束对于保证良好的状态是非常重要的
                // 如果一个非nil自定义视图可用，让我们来配置它
                view.prepareForReuse()
                
                if let customView = self.customView {
                    view.customView = customView
                } else {
                    // 从数据源获取数据
                    
                    let renderingMode: UIImage.RenderingMode = imageTintColor != nil ? .alwaysTemplate : .alwaysOriginal
                    
                    view.verticalSpace = verticalSpace
                    
                    // 配置图片
                    if let image = image {
                        view.imageView.image = image.withRenderingMode(renderingMode)
                        if let imageTintColor = imageTintColor {
                            view.imageView.tintColor = imageTintColor
                        }
                    }
                    
                    // 配置标题标签
                    if let titleLabelString = titleLabelString {
                        view.titleLabel.attributedText = titleLabelString
                    }
                    
                    // 配置详细标签
                    if let detailLabelString = detailLabelString {
                        view.detailLabel.attributedText = detailLabelString
                    }
                    
                    // 配置按钮
                    if let buttonImage = buttonImage(for: .normal) {
                        view.button.setImage(buttonImage, for: .normal)
                        view.button.setImage(self.buttonImage(for: .highlighted), for: .highlighted)
                    } else if let buttonTitle = buttonTitle(for: .normal) {
                        view.button.setAttributedTitle(buttonTitle, for: .normal)
                        view.button.setAttributedTitle(self.buttonTitle(for: .highlighted), for: .highlighted)
                        view.button.setBackgroundImage(self.buttonBackgroundImage(for: .normal), for: .normal)
                        view.button.setBackgroundImage(self.buttonBackgroundImage(for: .highlighted), for: .highlighted)
                    }
                }
                
                // 配置抵消
                view.verticalOffset = verticalOffset
                
                // 配置空数据集视图
                view.backgroundColor = dataSetBackgroundColor
                view.isHidden = false
                view.clipsToBounds = true
                
                // 配置空数据集userInteraction权限
                view.isUserInteractionEnabled = isTouchAllowed
                
                // 配置滚动许可
                self.isScrollEnabled = isScrollAllowed
                
                // 配置图像视图动画
                if self.isImageViewAnimateAllowed {
                    if let animation = imageAnimation {
                        view.imageView.layer.add(animation, forKey: nil)
                    }
                } else {
                    view.imageView.layer.removeAllAnimations()
                }
                
                if let config = configureEmptyDataSetView {
                    config(view)
                }
                
                view.setupConstraints()
                view.layoutIfNeeded()
            }
            
            // 通知已出现空数据集视图
            didAppear()
        } else if isEmptyDataSetVisible {
            invalidate()
        }
    }
    
    private func invalidate() {
        willDisappear()
        if let view = emptyDataSetView {
            view.prepareForReuse()
            view.isHidden = true
        }
        self.isScrollEnabled = true
        didDisappear()
    }
    
    private class func swizzleMethod(for aClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        
        let originalMethod = class_getInstanceMethod(aClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector)
        
        let didAddMethod = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
    
    private static let swizzleReloadData: () = {
        let tableViewOriginalSelector = #selector(UITableView.reloadData)
        let tableViewSwizzledSelector = #selector(UIScrollView.tableViewSwizzledReloadData)
        
        swizzleMethod(for: UITableView.self, originalSelector: tableViewOriginalSelector, swizzledSelector: tableViewSwizzledSelector)
        
        let collectionViewOriginalSelector = #selector(UICollectionView.reloadData)
        let collectionViewSwizzledSelector = #selector(UIScrollView.collectionViewSwizzledReloadData)
        
        swizzleMethod(for: UICollectionView.self, originalSelector: collectionViewOriginalSelector, swizzledSelector: collectionViewSwizzledSelector)
    }()
    
    private static let swizzleEndUpdates: () = {
        let originalSelector = #selector(UITableView.endUpdates)
        let swizzledSelector = #selector(UIScrollView.tableViewSwizzledEndUpdates)
        
        swizzleMethod(for: UITableView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    //MARK: - Method Swizzling
    @objc private func tableViewSwizzledReloadData() {
        tableViewSwizzledReloadData()
        reloadEmptyDataSet()
    }
    
    @objc private func tableViewSwizzledEndUpdates() {
        tableViewSwizzledEndUpdates()
        reloadEmptyDataSet()
    }
    
    @objc private func collectionViewSwizzledReloadData() {
        collectionViewSwizzledReloadData()
        reloadEmptyDataSet()
    }
}
