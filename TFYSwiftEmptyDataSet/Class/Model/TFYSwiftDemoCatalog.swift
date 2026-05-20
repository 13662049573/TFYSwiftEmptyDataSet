//
//  TFYSwiftDemoCatalog.swift
//  TFYSwiftEmptyDataSet
//

import UIKit

enum TFYSwiftEmptyDemo: Int, CaseIterable {
    case basic
    case configurationAPI
    case chainAPI
    case button
    case offsetSpacing
    case imageAnimation
    case customView
    case backgroundColor
    case buttonBackground
    case imageTint
    case loading
    case forceDisplay
    case collectionView
    case allFeatures

    var title: String {
        switch self {
        case .basic: return "基础空态（协议 Source）"
        case .configurationAPI: return "配置式 API（强引用）"
        case .chainAPI: return "链式 API（emptyDataSetView）"
        case .button: return "带操作按钮"
        case .offsetSpacing: return "垂直偏移与间距"
        case .imageAnimation: return "图片旋转动画"
        case .customView: return "完全自定义视图"
        case .backgroundColor: return "空态背景色"
        case .buttonBackground: return "按钮背景图"
        case .imageTint: return "图片 Template 着色"
        case .loading: return "加载中状态"
        case .forceDisplay: return "强制显示空态"
        case .collectionView: return "UICollectionView"
        case .allFeatures: return "全功能综合演示"
        }
    }

    var subtitle: String {
        switch self {
        case .basic: return "图片 + 标题 + 描述"
        case .configurationAPI: return "EmptyDataSetConfiguration"
        case .chainAPI: return "无需实现协议，闭包配置"
        case .button: return "点击按钮重试"
        case .offsetSpacing: return "verticalOffset / spaceHeight"
        case .imageAnimation: return "CAAnimation 无限旋转"
        case .customView: return "customView(forEmptyDataSet:)"
        case .backgroundColor: return "backgroundColor(forEmptyDataSet:)"
        case .buttonBackground: return "buttonBackgroundImage"
        case .imageTint: return "imageTintColor 模板色"
        case .loading: return "emptyDataSetIsLoading"
        case .forceDisplay: return "有数据时也显示空态"
        case .collectionView: return "网格列表空态"
        case .allFeatures: return "Delegate 生命周期 + 全部元素"
        }
    }

    func makeViewController() -> UIViewController {
        switch self {
        case .basic: return TFYSwiftEmptyOneController()
        case .configurationAPI: return TFYSwiftEmptyConfigurationController()
        case .chainAPI: return TFYSwiftEmptyChainController()
        case .button: return TFYSwiftEmptyTwoController()
        case .offsetSpacing: return TFYSwiftEmptyThreeController()
        case .imageAnimation: return TFYSwiftEmptyFourController()
        case .customView: return TFYSwiftEmptyFiveController()
        case .backgroundColor: return TFYSwiftEmptySixController()
        case .buttonBackground: return TFYSwiftEmptySevenController()
        case .imageTint: return TFYSwiftEmptyTintController()
        case .loading: return TFYSwiftEmptyLoadingController()
        case .forceDisplay: return TFYSwiftEmptyForceDisplayController()
        case .collectionView: return TFYSwiftEmptyCollectionController()
        case .allFeatures: return TFYSwiftEmptyEightController()
        }
    }
}
