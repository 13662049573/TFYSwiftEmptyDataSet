//
//  UIScrollView+EmptyDataSet.swift
//  TFYSwiftEmptyDataSet
//

import UIKit
import ObjectiveC

// MARK: - Associated Keys

private enum EmptyDataSetAssociatedKeys {
    static var source: UInt8 = 0
    static var delegate: UInt8 = 0
    static var view: UInt8 = 0
    static var configure: UInt8 = 0
    static var enabled: UInt8 = 0
    static var loading: UInt8 = 0
    static var savedScrollEnabled: UInt8 = 0
}

final class WeakObjectContainer: NSObject {
    weak var weakObject: AnyObject?

    init(with weakObject: Any?) {
        super.init()
        self.weakObject = weakObject as AnyObject?
    }
}

// MARK: - UIScrollView + Empty Data Set

extension UIScrollView: @retroactive UIGestureRecognizerDelegate {

    // MARK: Public API

    /// 总开关；设为 `false` 时不展示空态（不影响数据源刷新）
    public var isEmptyDataSetEnabled: Bool {
        get {
            (objc_getAssociatedObject(self, &EmptyDataSetAssociatedKeys.enabled) as? Bool) ?? true
        }
        set {
            objc_setAssociatedObject(self, &EmptyDataSetAssociatedKeys.enabled, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if !newValue {
                invalidate()
            } else {
                reloadEmptyDataSet()
            }
        }
    }

    /// 加载中：为 `true` 时在无数据情况下强制展示空态（通常配合 `customView` 或 Source 返回加载视图）
    public var emptyDataSetIsLoading: Bool {
        get {
            (objc_getAssociatedObject(self, &EmptyDataSetAssociatedKeys.loading) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &EmptyDataSetAssociatedKeys.loading, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            reloadEmptyDataSet()
        }
    }

    public var emptyDataSetSource: EmptyDataSetSource? {
        get {
            let container = objc_getAssociatedObject(self, &EmptyDataSetAssociatedKeys.source) as? WeakObjectContainer
            return container?.weakObject as? EmptyDataSetSource
        }
        set {
            if newValue == nil {
                invalidate()
            }
            objc_setAssociatedObject(self, &EmptyDataSetAssociatedKeys.source, WeakObjectContainer(with: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            _ = UIScrollView.swizzleEmptyDataSetIfNeeded
            reloadEmptyDataSet()
        }
    }

    public var emptyDataSetDelegate: EmptyDataSetDelegate? {
        get {
            let container = objc_getAssociatedObject(self, &EmptyDataSetAssociatedKeys.delegate) as? WeakObjectContainer
            return container?.weakObject as? EmptyDataSetDelegate
        }
        set {
            if newValue == nil {
                invalidate()
            }
            objc_setAssociatedObject(self, &EmptyDataSetAssociatedKeys.delegate, WeakObjectContainer(with: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var isEmptyDataSetVisible: Bool {
        guard let view = objc_getAssociatedObject(self, &EmptyDataSetAssociatedKeys.view) as? TFYSwiftEmptyDataSetView else {
            return false
        }
        return !view.isHidden && view.superview != nil
    }

    /// 当前列表项数量（供链式 API 与调试使用）
    public var emptyDataSetItemCount: Int {
        itemsCount
    }

    public func emptyDataSetView(_ closure: @escaping (TFYSwiftEmptyDataSetView) -> Void) {
        configureEmptyDataSetView = closure
        _ = UIScrollView.swizzleEmptyDataSetIfNeeded
        reloadEmptyDataSet()
    }

    public func reloadEmptyDataSet() {
        guard isEmptyDataSetEnabled else {
            invalidate()
            return
        }
        guard emptyDataSetSource != nil || configureEmptyDataSetView != nil else {
            return
        }

        let shouldShow = (shouldDisplay
            && !shouldSuppressForTableHeader
            && (itemsCount == 0 || emptyDataSetIsLoading))
            || shouldBeForcedToDisplay

        if shouldShow {
            let wasVisible = isEmptyDataSetVisible
            if !wasVisible {
                willAppear()
            }

            guard let view = emptyDataSetView else { return }

            if view.superview != nil, view.superview !== self {
                view.removeFromSuperview()
            }

            if view.superview == nil {
                if self is UITableView || self is UICollectionView || subviews.count > 1 {
                    insertSubview(view, at: 0)
                } else {
                    addSubview(view)
                }
            }
            bringSubviewToFront(view)

            // 抑制内容重建过程中可能触发的 Core Animation 隐式动画，避免闪烁
            CATransaction.begin()
            CATransaction.setDisableActions(true)

            view.fadeInOnDisplay = shouldFadeIn
            view.prepareForReuse()

            if emptyDataSetIsLoading {
                let loadingView = emptyDataSetSource?.customView(forEmptyDataSet: self) ?? makeDefaultLoadingView()
                view.customView = loadingView
            } else if let sourceCustomView {
                view.customView = sourceCustomView
            } else {
                let renderingMode: UIImage.RenderingMode = imageTintColor != nil ? .alwaysTemplate : .alwaysOriginal
                view.verticalSpace = verticalSpace
                view.preferredMaxImageWidth = imageMaxWidth
                view.customImageSize = customImageSize

                if let image = image {
                    view.imageView.image = image.withRenderingMode(renderingMode)
                    view.imageView.tintColor = imageTintColor
                }

                view.titleLabel.attributedText = titleLabelString
                view.detailLabel.attributedText = detailLabelString

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

            view.verticalOffset = verticalOffset
            view.backgroundColor = dataSetBackgroundColor
            view.isHidden = false
            view.clipsToBounds = true
            view.isUserInteractionEnabled = isTouchAllowed

            saveScrollEnabledIfNeeded()
            isScrollEnabled = isScrollAllowed

            view.imageView.layer.removeAllAnimations()
            if isImageViewAnimateAllowed, let animation = imageAnimation {
                view.imageView.layer.add(animation, forKey: "emptyDataSet.imageAnimation")
            }

            configureEmptyDataSetView?(view)

            updateEmptyDataSetViewFrame()
            view.setupConstraints()
            view.layoutIfNeeded()

            CATransaction.commit()

            // 只在从隐藏到显示的转场时执行淡入；后续刷新直接保持可见，杜绝闪烁
            view.applyContentVisibility(animated: !wasVisible)

            if !wasVisible {
                didAppear()
            }
        } else if isEmptyDataSetVisible {
            invalidate()
        } else {
            updateEmptyDataSetViewFrame()
        }
    }

    // MARK: Private storage

    private var configureEmptyDataSetView: ((TFYSwiftEmptyDataSetView) -> Void)? {
        get {
            objc_getAssociatedObject(self, &EmptyDataSetAssociatedKeys.configure) as? (TFYSwiftEmptyDataSetView) -> Void
        }
        set {
            objc_setAssociatedObject(self, &EmptyDataSetAssociatedKeys.configure, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var emptyDataSetView: TFYSwiftEmptyDataSetView? {
        get {
            if let view = objc_getAssociatedObject(self, &EmptyDataSetAssociatedKeys.view) as? TFYSwiftEmptyDataSetView {
                return view
            }
            let view = TFYSwiftEmptyDataSetView(frame: bounds)
            view.isHidden = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapContentView(_:)))
            tapGesture.delegate = self
            view.addGestureRecognizer(tapGesture)
            view.button.addTarget(self, action: #selector(didTapDataButton(_:)), for: .touchUpInside)
            objc_setAssociatedObject(self, &EmptyDataSetAssociatedKeys.view, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return view
        }
        set {
            objc_setAssociatedObject(self, &EmptyDataSetAssociatedKeys.view, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: Item count

    var itemsCount: Int {
        if let tableView = self as? UITableView, let dataSource = tableView.dataSource {
            let sections = dataSource.numberOfSections?(in: tableView) ?? 1
            return (0..<sections).reduce(0) { total, section in
                total + dataSource.tableView(tableView, numberOfRowsInSection: section)
            }
        }

        if let collectionView = self as? UICollectionView, let dataSource = collectionView.dataSource {
            let sections = dataSource.numberOfSections?(in: collectionView) ?? 1
            return (0..<sections).reduce(0) { total, section in
                total + dataSource.collectionView(collectionView, numberOfItemsInSection: section)
            }
        }

        return 0
    }

    /// 仅在 delegate 显式要求且存在可见 `tableHeaderView` 时才隐藏空态；默认不隐藏
    private var shouldSuppressForTableHeader: Bool {
        guard let tableView = self as? UITableView else { return false }
        guard emptyDataSetDelegate?.emptyDataSetShouldHideWhenTableHeaderVisible(self) == true else {
            return false
        }
        guard let header = tableView.tableHeaderView else { return false }
        return header.frame.height > 0.01
    }

    /// 计算空态视图相对 `scrollView.bounds` 的位置（避让 tableHeaderView 与 tableFooterView）
    private var emptyDataSetReservedInsets: UIEdgeInsets {
        guard let tableView = self as? UITableView else { return .zero }
        let top = tableView.tableHeaderView?.frame.height ?? 0
        let bottom = tableView.tableFooterView?.frame.height ?? 0
        return UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
    }

    // MARK: Source getters

    private var titleLabelString: NSAttributedString? {
        emptyDataSetSource?.title(forEmptyDataSet: self)
    }

    private var detailLabelString: NSAttributedString? {
        emptyDataSetSource?.description(forEmptyDataSet: self)
    }

    private var image: UIImage? {
        emptyDataSetSource?.image(forEmptyDataSet: self)
    }

    private var imageAnimation: CAAnimation? {
        emptyDataSetSource?.imageAnimation(forEmptyDataSet: self)
    }

    private var imageTintColor: UIColor? {
        emptyDataSetSource?.imageTintColor(forEmptyDataSet: self)
    }

    private var customImageSize: CGSize? {
        emptyDataSetSource?.imageSize(forEmptyDataSet: self)
    }

    private var imageMaxWidth: CGFloat {
        emptyDataSetSource?.imageMaxWidth(forEmptyDataSet: self) ?? EmptyDataSetContent.defaultImageMaxWidth
    }

    private func buttonTitle(for state: UIControl.State) -> NSAttributedString? {
        emptyDataSetSource?.buttonTitle(forEmptyDataSet: self, for: state)
    }

    private func buttonImage(for state: UIControl.State) -> UIImage? {
        emptyDataSetSource?.buttonImage(forEmptyDataSet: self, for: state)
    }

    private func buttonBackgroundImage(for state: UIControl.State) -> UIImage? {
        emptyDataSetSource?.buttonBackgroundImage(forEmptyDataSet: self, for: state)
    }

    private var dataSetBackgroundColor: UIColor? {
        emptyDataSetSource?.backgroundColor(forEmptyDataSet: self)
    }

    private var sourceCustomView: UIView? {
        emptyDataSetSource?.customView(forEmptyDataSet: self)
    }

    private var verticalOffset: CGFloat {
        emptyDataSetSource?.verticalOffset(forEmptyDataSet: self) ?? 0
    }

    private var verticalSpace: CGFloat {
        let value = emptyDataSetSource?.spaceHeight(forEmptyDataSet: self) ?? 11
        return value > 0 ? value : 11
    }

    // MARK: Delegate getters

    private var shouldFadeIn: Bool {
        emptyDataSetDelegate?.emptyDataSetShouldFadeIn(self) ?? true
    }

    private var shouldDisplay: Bool {
        emptyDataSetDelegate?.emptyDataSetShouldDisplay(self) ?? true
    }

    private var shouldBeForcedToDisplay: Bool {
        emptyDataSetDelegate?.emptyDataSetShouldBeForcedToDisplay(self) ?? false
    }

    private var isTouchAllowed: Bool {
        emptyDataSetDelegate?.emptyDataSetShouldAllowTouch(self) ?? true
    }

    private var isScrollAllowed: Bool {
        emptyDataSetDelegate?.emptyDataSetShouldAllowScroll(self) ?? false
    }

    private var isImageViewAnimateAllowed: Bool {
        emptyDataSetDelegate?.emptyDataSetShouldAnimateImageView(self) ?? false
    }

    // MARK: Lifecycle callbacks

    private func willAppear() {
        emptyDataSetDelegate?.emptyDataSetWillAppear(self)
        emptyDataSetView?.willAppearHandle?()
    }

    private func didAppear() {
        emptyDataSetDelegate?.emptyDataSetDidAppear(self)
        emptyDataSetView?.didAppearHandle?()
    }

    private func willDisappear() {
        emptyDataSetDelegate?.emptyDataSetWillDisappear(self)
        emptyDataSetView?.willDisappearHandle?()
    }

    private func didDisappear() {
        emptyDataSetDelegate?.emptyDataSetDidDisappear(self)
        emptyDataSetView?.didDisappearHandle?()
    }

    /// UIKit 手势 target 需要 selector，仅内部使用
    @objc private func didTapContentView(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        emptyDataSetDelegate?.emptyDataSet(self, didTapView: view)
        emptyDataSetView?.didTapContentViewHandle?()
    }

    @objc private func didTapDataButton(_ sender: UIButton) {
        emptyDataSetDelegate?.emptyDataSet(self, didTapButton: sender)
        emptyDataSetView?.didTapDataButtonHandle?()
    }

    // MARK: Invalidate

    private func invalidate() {
        let wasVisible = isEmptyDataSetVisible
        if wasVisible {
            willDisappear()
        }
        if let view = emptyDataSetView {
            view.prepareForReuse()
            view.isHidden = true
        }
        restoreScrollEnabledIfNeeded()
        if wasVisible {
            didDisappear()
        }
    }

    // MARK: Layout

    func updateEmptyDataSetViewFrame() {
        guard let view = objc_getAssociatedObject(self, &EmptyDataSetAssociatedKeys.view) as? TFYSwiftEmptyDataSetView,
              view.superview === self else { return }

        let fallbackWidth = bounds.width > 0 ? bounds.width : UIScreen.main.bounds.width
        let fallbackHeight = bounds.height > 0 ? bounds.height : UIScreen.main.bounds.height
        let baseWidth = bounds.width > 0 ? bounds.width : fallbackWidth
        let baseHeight = bounds.height > 0 ? bounds.height : fallbackHeight

        let insets = emptyDataSetReservedInsets
        let originY = insets.top
        let availableHeight = max(baseHeight - insets.top - insets.bottom, 0)
        let finalHeight = availableHeight > 0 ? availableHeight : baseHeight

        view.frame = CGRect(x: 0, y: originY, width: baseWidth, height: finalHeight)
    }

    private func makeDefaultLoadingView() -> UIView {
        EmptyDataSetContent.makeLoadingView(text: nil)
    }

    // MARK: Scroll state

    private var savedScrollEnabled: Bool? {
        get {
            objc_getAssociatedObject(self, &EmptyDataSetAssociatedKeys.savedScrollEnabled) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &EmptyDataSetAssociatedKeys.savedScrollEnabled, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private func saveScrollEnabledIfNeeded() {
        if savedScrollEnabled == nil {
            savedScrollEnabled = isScrollEnabled
        }
    }

    private func restoreScrollEnabledIfNeeded() {
        if let saved = savedScrollEnabled {
            isScrollEnabled = saved
            savedScrollEnabled = nil
        }
    }

    // MARK: UIGestureRecognizerDelegate

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        isScrollAllowed
    }

    // MARK: Method swizzling

    private static let swizzleEmptyDataSetIfNeeded: () = {
        swizzleMethod(for: UITableView.self,
                      original: #selector(UITableView.reloadData),
                      swizzled: #selector(UIScrollView.tfy_tableViewSwizzledReloadData))
        swizzleMethod(for: UITableView.self,
                      original: #selector(UITableView.endUpdates),
                      swizzled: #selector(UIScrollView.tfy_tableViewSwizzledEndUpdates))
        swizzleMethod(for: UICollectionView.self,
                      original: #selector(UICollectionView.reloadData),
                      swizzled: #selector(UIScrollView.tfy_collectionViewSwizzledReloadData))
        swizzleMethod(for: UIScrollView.self,
                      original: #selector(UIScrollView.layoutSubviews),
                      swizzled: #selector(UIScrollView.tfy_swizzledLayoutSubviews))
    }()

    private class func swizzleMethod(for aClass: AnyClass, original: Selector, swizzled: Selector) {
        guard let originalMethod = class_getInstanceMethod(aClass, original),
              let swizzledMethod = class_getInstanceMethod(aClass, swizzled) else {
            return
        }
        if class_addMethod(aClass, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
            class_replaceMethod(aClass, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

    /// Method Swizzling 依赖 Objective-C 运行时，仅库内部使用
    @objc private func tfy_tableViewSwizzledReloadData() {
        tfy_tableViewSwizzledReloadData()
        reloadEmptyDataSet()
    }

    @objc private func tfy_tableViewSwizzledEndUpdates() {
        tfy_tableViewSwizzledEndUpdates()
        reloadEmptyDataSet()
    }

    @objc private func tfy_collectionViewSwizzledReloadData() {
        tfy_collectionViewSwizzledReloadData()
        reloadEmptyDataSet()
    }

    @objc private func tfy_swizzledLayoutSubviews() {
        tfy_swizzledLayoutSubviews()
        updateEmptyDataSetViewFrame()
    }
}
