# TFYSwiftEmptyDataSet

[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-blue.svg?style=flat)](https://developer.apple.com/iphone/)
[![Language](https://img.shields.io/badge/language-Swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](LICENSE)

优雅处理 `UITableView` / `UICollectionView` 空数据与加载态的 Swift 库，支持协议与链式两种配置方式。

## 特性

- UITableView / UICollectionView 自动 hook `reloadData`
- **协议** `EmptyDataSetSource` / `EmptyDataSetDelegate`
- **配置式** `EmptyDataSetConfiguration`，库内部强引用配置适配器
- **链式** `emptyDataSetView { }` 闭包配置
- 图片、标题、描述、按钮、自定义视图
- 图片 Template 着色与 CAAnimation
- 垂直偏移、元素间距、背景色
- 图片尺寸、内容边距、最大内容宽度、按钮内边距
- **加载态** `emptyDataSetIsLoading`
- **强制显示** `emptyDataSetShouldBeForcedToDisplay`
- 滚动/点击权限、淡入动画、生命周期回调、可访问性文案
- 支持 `reloadData`、insert/delete/reload rows/items/sections、batch updates 后自动刷新
- 深色模式语义色（`EmptyDataSetContent`）
- 最低 **iOS 15+**

## 要求

- iOS 15.0+
- Swift 5.0+
- Xcode 14.0+

## 安装

### Swift Package Manager

在 Xcode 中选择 `File > Add Package Dependencies...`，输入仓库地址：

```text
https://github.com/13662049573/TFYSwiftEmptyDataSet.git
```

然后选择 `TFYSwiftEmptyDataSetKit` library product。

也可以在 `Package.swift` 中添加：

```swift
.package(url: "https://github.com/13662049573/TFYSwiftEmptyDataSet.git", from: "2.1.1")
```

### CocoaPods

```ruby
pod 'TFYSwiftEmptyDataSetKit', '~> 2.1.1'
```

### 源码

将 `TFYSwiftEmptyDataSetKit` 目录拖入工程即可。

## 用法

### 协议方式（纯 Swift，无需 `@objc`）

实现 `EmptyDataSetSource` / `EmptyDataSetDelegate`，只写需要定制的方法，其余走协议 extension 默认值：

```swift
final class ListController: UIViewController, EmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        EmptyDataSetContent.title("暂无数据")
    }
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        UIImage(named: "empty")
    }
}

// viewDidLoad 中
tableView.emptyDataSetSource = self
```

### 链式方式

```swift
tableView.emptyDataSetView { view in
    view
        .image(UIImage(named: "empty"))
        .titleLabelString(EmptyDataSetContent.title("暂无数据"))
        .detailLabelString(EmptyDataSetContent.detail("下拉刷新试试"))
        .buttonTitle(EmptyDataSetContent.buttonTitle("重试"), for: .normal)
        .imageSize(CGSize(width: 92, height: 92))
        .contentInsets(UIEdgeInsets(top: 12, left: 28, bottom: 12, right: 28))
        .maximumContentWidth(320)
        .buttonContentInsets(NSDirectionalEdgeInsets(top: 10, leading: 18, bottom: 10, trailing: 18))
        .accessibilityLabel("暂无数据，点击重试")
        .didTapDataButton { /* 重试 */ }
}
```

### 配置式方式

```swift
tableView.setEmptyDataSetConfiguration(
    EmptyDataSetConfiguration(
        title: EmptyDataSetContent.title("暂无数据"),
        detail: EmptyDataSetContent.detail("稍后再来看看"),
        image: UIImage(named: "empty"),
        buttonTitle: EmptyDataSetContent.buttonTitle("重试"),
        imageSize: CGSize(width: 92, height: 92),
        maximumContentWidth: 320,
        accessibilityLabel: "暂无数据，点击重试"
    ),
    onTapButton: {
        // 重试
    }
)
```

### 加载中

```swift
tableView.emptyDataSetIsLoading = true
tableView.reloadData()
// 请求结束后
tableView.emptyDataSetIsLoading = false
tableView.reloadData()
```

### UICollectionView

与 TableView 相同，设置 `emptyDataSetSource` / `emptyDataSetDelegate` 或链式 API 即可。

## Demo

运行示例 App，首页列出 14 个场景（基础空态、配置式 API、链式 API、按钮、偏移、动画、自定义视图、CollectionView、加载态、强制显示、综合能力等）。

## 许可证

MIT — 见 [LICENSE](LICENSE)
