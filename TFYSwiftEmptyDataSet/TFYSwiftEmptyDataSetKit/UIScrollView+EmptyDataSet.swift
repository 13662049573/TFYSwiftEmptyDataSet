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
    static var configurationAdapter: UInt8 = 0
}

final class WeakObjectContainer: NSObject {
    weak var weakObject: AnyObject?

    init(with weakObject: Any?) {
        super.init()
        self.weakObject = weakObject as AnyObject?
    }
}

private final class EmptyDataSetConfigurationAdapter: NSObject, EmptyDataSetSource, EmptyDataSetDelegate {
    private let configuration: EmptyDataSetConfiguration
    private let onTapView: (() -> Void)?
    private let onTapButton: (() -> Void)?

    init(
        configuration: EmptyDataSetConfiguration,
        onTapView: (() -> Void)?,
        onTapButton: (() -> Void)?
    ) {
        self.configuration = configuration
        self.onTapView = onTapView
        self.onTapButton = onTapButton
        super.init()
    }

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? { configuration.title }
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? { configuration.detail }
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? { configuration.image }
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? { configuration.imageTintColor }
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? { configuration.imageAnimation }
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? { configuration.backgroundColor }
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? { configuration.customView }
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat { configuration.verticalOffset }
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat { configuration.verticalSpace }
    func imageSize(forEmptyDataSet scrollView: UIScrollView) -> CGSize { configuration.imageSize }
    func contentInsets(forEmptyDataSet scrollView: UIScrollView) -> UIEdgeInsets { configuration.contentInsets }
    func maximumContentWidth(forEmptyDataSet scrollView: UIScrollView) -> CGFloat { configuration.maximumContentWidth }
    func buttonContentInsets(forEmptyDataSet scrollView: UIScrollView) -> NSDirectionalEdgeInsets { configuration.buttonContentInsets }
    func accessibilityLabel(forEmptyDataSet scrollView: UIScrollView) -> String? { configuration.accessibilityLabel }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        state == .highlighted ? configuration.highlightedButtonTitle : configuration.buttonTitle
    }

    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        state == .highlighted ? configuration.highlightedButtonImage : configuration.buttonImage
    }

    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        state == .highlighted ? configuration.highlightedButtonBackgroundImage : configuration.buttonBackgroundImage
    }

    func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool { configuration.shouldFadeIn }
    func emptyDataSetShouldBeForcedToDisplay(_ scrollView: UIScrollView) -> Bool { configuration.shouldForceDisplay }
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool { configuration.shouldAllowTouch }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { configuration.shouldAllowScroll }
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool { configuration.shouldAnimateImage }

    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        onTapView?()
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        onTapButton?()
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

    public func setEmptyDataSetConfiguration(
        _ configuration: EmptyDataSetConfiguration,
        onTapView: (() -> Void)? = nil,
        onTapButton: (() -> Void)? = nil
    ) {
        let adapter = EmptyDataSetConfigurationAdapter(
            configuration: configuration,
            onTapView: onTapView,
            onTapButton: onTapButton
        )
        objc_setAssociatedObject(self, &EmptyDataSetAssociatedKeys.configurationAdapter, adapter, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        emptyDataSetSource = adapter
        emptyDataSetDelegate = adapter
        _ = UIScrollView.swizzleEmptyDataSetIfNeeded
        reloadEmptyDataSet()
    }

    public func removeEmptyDataSetConfiguration() {
        objc_setAssociatedObject(self, &EmptyDataSetAssociatedKeys.configurationAdapter, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        emptyDataSetSource = nil
        emptyDataSetDelegate = nil
        invalidate()
    }

    public func reloadEmptyDataSet() {
        guard isEmptyDataSetEnabled else {
            invalidate()
            return
        }
        guard emptyDataSetSource != nil || configureEmptyDataSetView != nil else {
            return
        }

        let shouldShow = (shouldDisplay && (itemsCount == 0 || emptyDataSetIsLoading)) || shouldBeForcedToDisplay

        if shouldShow {
            let wasVisible = isEmptyDataSetVisible
            if !wasVisible {
                willAppear()
            }
            guard let view = emptyDataSetView else { return }

            view.prepareForReuse()

            if view.superview != nil, view.superview !== self {
                view.removeFromSuperview()
            }

            view.fadeInOnDisplay = shouldFadeIn

            if view.superview == nil {
                addSubview(view)
            }
            bringSubviewToFront(view)

            if emptyDataSetIsLoading {
                let loadingView = emptyDataSetSource?.customView(forEmptyDataSet: self) ?? makeDefaultLoadingView()
                view.customView = loadingView
            } else if let sourceCustomView {
                view.customView = sourceCustomView
            } else {
                let renderingMode: UIImage.RenderingMode = imageTintColor != nil ? .alwaysTemplate : .alwaysOriginal
                view.verticalSpace = verticalSpace
                view.imageSize = imageSize
                view.contentInsets = contentInsets
                view.maximumContentWidth = maximumContentWidth
                view.buttonContentInsets = buttonContentInsets

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
            view.isAccessibilityElement = emptyDataSetAccessibilityLabel != nil
            view.accessibilityLabel = emptyDataSetAccessibilityLabel

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

            if view.fadeInOnDisplay && !wasVisible {
                view.contentView.alpha = 0
                UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut, .allowUserInteraction]) {
                    view.contentView.alpha = 1
                }
            } else {
                view.contentView.alpha = 1
            }

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
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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

    private var imageSize: CGSize {
        emptyDataSetSource?.imageSize(forEmptyDataSet: self) ?? .zero
    }

    private var contentInsets: UIEdgeInsets {
        emptyDataSetSource?.contentInsets(forEmptyDataSet: self) ?? UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    private var maximumContentWidth: CGFloat {
        emptyDataSetSource?.maximumContentWidth(forEmptyDataSet: self) ?? 0
    }

    private var buttonContentInsets: NSDirectionalEdgeInsets {
        emptyDataSetSource?.buttonContentInsets(forEmptyDataSet: self)
            ?? NSDirectionalEdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14)
    }

    private var emptyDataSetAccessibilityLabel: String? {
        emptyDataSetSource?.accessibilityLabel(forEmptyDataSet: self)
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
        guard isEmptyDataSetVisible else {
            restoreScrollEnabledIfNeeded()
            return
        }
        willDisappear()
        if let view = emptyDataSetView {
            view.prepareForReuse()
            view.isHidden = true
            view.contentView.alpha = 0
        }
        restoreScrollEnabledIfNeeded()
        didDisappear()
    }

    // MARK: Layout

    func updateEmptyDataSetViewFrame() {
        guard let view = objc_getAssociatedObject(self, &EmptyDataSetAssociatedKeys.view) as? TFYSwiftEmptyDataSetView,
              view.superview === self else { return }
        var rect = bounds
        rect.origin = .zero
        if rect.width <= 0 || rect.height <= 0 {
            rect = CGRect(origin: .zero, size: CGSize(width: bounds.width > 0 ? bounds.width : UIScreen.main.bounds.width,
                                                     height: bounds.height > 0 ? bounds.height : UIScreen.main.bounds.height))
        }
        view.frame = rect
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
        swizzleMethod(for: UITableView.self,
                      original: #selector(UITableView.insertRows(at:with:)),
                      swizzled: #selector(UIScrollView.tfy_tableViewSwizzledInsertRows(at:with:)))
        swizzleMethod(for: UITableView.self,
                      original: #selector(UITableView.deleteRows(at:with:)),
                      swizzled: #selector(UIScrollView.tfy_tableViewSwizzledDeleteRows(at:with:)))
        swizzleMethod(for: UITableView.self,
                      original: #selector(UITableView.reloadRows(at:with:)),
                      swizzled: #selector(UIScrollView.tfy_tableViewSwizzledReloadRows(at:with:)))
        swizzleMethod(for: UITableView.self,
                      original: #selector(UITableView.insertSections(_:with:)),
                      swizzled: #selector(UIScrollView.tfy_tableViewSwizzledInsertSections(_:with:)))
        swizzleMethod(for: UITableView.self,
                      original: #selector(UITableView.deleteSections(_:with:)),
                      swizzled: #selector(UIScrollView.tfy_tableViewSwizzledDeleteSections(_:with:)))
        swizzleMethod(for: UITableView.self,
                      original: #selector(UITableView.reloadSections(_:with:)),
                      swizzled: #selector(UIScrollView.tfy_tableViewSwizzledReloadSections(_:with:)))
        swizzleMethod(for: UITableView.self,
                      original: #selector(UITableView.performBatchUpdates(_:completion:)),
                      swizzled: #selector(UIScrollView.tfy_tableViewSwizzledPerformBatchUpdates(_:completion:)))
        swizzleMethod(for: UICollectionView.self,
                      original: #selector(UICollectionView.reloadData),
                      swizzled: #selector(UIScrollView.tfy_collectionViewSwizzledReloadData))
        swizzleMethod(for: UICollectionView.self,
                      original: #selector(UICollectionView.insertItems(at:)),
                      swizzled: #selector(UIScrollView.tfy_collectionViewSwizzledInsertItems(at:)))
        swizzleMethod(for: UICollectionView.self,
                      original: #selector(UICollectionView.deleteItems(at:)),
                      swizzled: #selector(UIScrollView.tfy_collectionViewSwizzledDeleteItems(at:)))
        swizzleMethod(for: UICollectionView.self,
                      original: #selector(UICollectionView.reloadItems(at:)),
                      swizzled: #selector(UIScrollView.tfy_collectionViewSwizzledReloadItems(at:)))
        swizzleMethod(for: UICollectionView.self,
                      original: #selector(UICollectionView.insertSections(_:)),
                      swizzled: #selector(UIScrollView.tfy_collectionViewSwizzledInsertSections(_:)))
        swizzleMethod(for: UICollectionView.self,
                      original: #selector(UICollectionView.deleteSections(_:)),
                      swizzled: #selector(UIScrollView.tfy_collectionViewSwizzledDeleteSections(_:)))
        swizzleMethod(for: UICollectionView.self,
                      original: #selector(UICollectionView.reloadSections(_:)),
                      swizzled: #selector(UIScrollView.tfy_collectionViewSwizzledReloadSections(_:)))
        swizzleMethod(for: UICollectionView.self,
                      original: #selector(UICollectionView.performBatchUpdates(_:completion:)),
                      swizzled: #selector(UIScrollView.tfy_collectionViewSwizzledPerformBatchUpdates(_:completion:)))
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

    @objc private func tfy_tableViewSwizzledInsertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tfy_tableViewSwizzledInsertRows(at: indexPaths, with: animation)
        reloadEmptyDataSet()
    }

    @objc private func tfy_tableViewSwizzledDeleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tfy_tableViewSwizzledDeleteRows(at: indexPaths, with: animation)
        reloadEmptyDataSet()
    }

    @objc private func tfy_tableViewSwizzledReloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tfy_tableViewSwizzledReloadRows(at: indexPaths, with: animation)
        reloadEmptyDataSet()
    }

    @objc private func tfy_tableViewSwizzledInsertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        tfy_tableViewSwizzledInsertSections(sections, with: animation)
        reloadEmptyDataSet()
    }

    @objc private func tfy_tableViewSwizzledDeleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        tfy_tableViewSwizzledDeleteSections(sections, with: animation)
        reloadEmptyDataSet()
    }

    @objc private func tfy_tableViewSwizzledReloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        tfy_tableViewSwizzledReloadSections(sections, with: animation)
        reloadEmptyDataSet()
    }

    @objc private func tfy_tableViewSwizzledPerformBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        tfy_tableViewSwizzledPerformBatchUpdates(updates) { finished in
            self.reloadEmptyDataSet()
            completion?(finished)
        }
    }

    @objc private func tfy_collectionViewSwizzledReloadData() {
        tfy_collectionViewSwizzledReloadData()
        reloadEmptyDataSet()
    }

    @objc private func tfy_collectionViewSwizzledInsertItems(at indexPaths: [IndexPath]) {
        tfy_collectionViewSwizzledInsertItems(at: indexPaths)
        reloadEmptyDataSet()
    }

    @objc private func tfy_collectionViewSwizzledDeleteItems(at indexPaths: [IndexPath]) {
        tfy_collectionViewSwizzledDeleteItems(at: indexPaths)
        reloadEmptyDataSet()
    }

    @objc private func tfy_collectionViewSwizzledReloadItems(at indexPaths: [IndexPath]) {
        tfy_collectionViewSwizzledReloadItems(at: indexPaths)
        reloadEmptyDataSet()
    }

    @objc private func tfy_collectionViewSwizzledInsertSections(_ sections: IndexSet) {
        tfy_collectionViewSwizzledInsertSections(sections)
        reloadEmptyDataSet()
    }

    @objc private func tfy_collectionViewSwizzledDeleteSections(_ sections: IndexSet) {
        tfy_collectionViewSwizzledDeleteSections(sections)
        reloadEmptyDataSet()
    }

    @objc private func tfy_collectionViewSwizzledReloadSections(_ sections: IndexSet) {
        tfy_collectionViewSwizzledReloadSections(sections)
        reloadEmptyDataSet()
    }

    @objc private func tfy_collectionViewSwizzledPerformBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        tfy_collectionViewSwizzledPerformBatchUpdates(updates) { finished in
            self.reloadEmptyDataSet()
            completion?(finished)
        }
    }

    @objc private func tfy_swizzledLayoutSubviews() {
        tfy_swizzledLayoutSubviews()
        updateEmptyDataSetViewFrame()
    }
}
