# TFYSwiftEmptyDataSet

[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](https://img.shields.io/badge/language-Swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/13662049573/TFYSwiftEmptyDataSet/blob/main/LICENSE)

一个优雅的方式来处理 UITableView/UICollectionView 的空数据状态，完全用 Swift 编写。

## 特性

- [x] 支持 UITableView 和 UICollectionView
- [x] 完全用 Swift 编写，支持链式调用
- [x] 高度可定制的空状态视图
- [x] 支持图片、标题、详细描述、按钮等组件
- [x] 支持自定义视图
- [x] 支持图片动画
- [x] 支持垂直偏移和间距调整
- [x] 支持点击事件处理
- [x] 支持滚动控制
- [x] 自动处理数据加载状态

## 预览

[这里放置 2-3 张效果图]

## 要求

- iOS 12.0+
- Swift 5.0+
- Xcode 12.0+

## 安装

### CocoaPods

```ruby
pod 'TFYSwiftEmptyDataSet'
```

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/13662049573/TFYSwiftEmptyDataSet.git", .upToNextMajor(from: "2.0.5"))
]
```

## 使用方法

### 基础用法

```swift
import TFYSwiftEmptyDataSet

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置空数据状态
        tableView.emptyDataSetView { emptyView in
            emptyView
                .image(UIImage(named: "empty_icon"))
                .titleLabelString(NSAttributedString(string: "暂无数据"))
                .detailLabelString(NSAttributedString(string: "点击刷新试试"))
                .didTapContentView {
                    print("点击了空视图")
                }
        }
    }
}
```

### 高级配置

```swift
tableView.emptyDataSetView { emptyView in
    emptyView
        .image(UIImage(named: "empty_icon"))
        .imageTintColor(.gray)
        .titleLabelString(NSAttributedString(
            string: "没有搜索结果",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 17),
                .foregroundColor: UIColor.darkGray
            ]
        ))
        .detailLabelString(NSAttributedString(
            string: "换个关键词试试",
            attributes: [
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.gray
            ]
        ))
        .buttonTitle(NSAttributedString(string: "重新加载"), for: .normal)
        .verticalOffset(50)
        .verticalSpace(20)
        .shouldFadeIn(true)
        .isScrollAllowed(false)
        .didTapDataButton {
            print("点击了按钮")
        }
}
```

## 自定义

### 使用自定义视图

```swift
let customView = CustomEmptyView()
tableView.emptyDataSetView { emptyView in
    emptyView.customView(customView)
}
```

### 添加动画

```swift
let animation = CABasicAnimation(keyPath: "transform.rotation.z")
animation.duration = 1.0
animation.repeatCount = .infinity

tableView.emptyDataSetView { emptyView in
    emptyView
        .image(UIImage(named: "loading"))
        .imageAnimation(animation)
}
```

## 代理方法

通过实现 `EmptyDataSetDelegate` 协议来控制空数据集的行为：

```swift
extension ViewController: EmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func emptyDataSetDidTapView(_ scrollView: UIScrollView) {
        // 处理点击事件
    }
}
```

## 注意事项

1. 确保在设置数据源和代理之后再配置空数据视图
2. 如果使用自定义视图，需要自行处理约束
3. 建议在主线程更新 UI

## 贡献

欢迎提交 Issue 和 Pull Request

## 许可证

TFYSwiftEmptyDataSet 基于 MIT 许可证开源。详细内容请查看 [LICENSE](LICENSE) 文件。
