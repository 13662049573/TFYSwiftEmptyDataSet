
Pod::Spec.new do |spec|

  spec.name         = "TFYSwiftEmptyDataSetKit"

  spec.version      = "2.0.0"

  spec.summary      = "Swift 版的数据空添加图数据 最低支持iOS 13 Swift5"

  spec.description  = <<-DESC
  Swift 版的数据空添加图数据 最低支持iOS 13 Swift5
                   DESC

  spec.homepage     = "https://github.com/13662049573/TFYSwiftEmptyDataSet"
  
  spec.license      = "MIT"
  
  spec.author       = { "田风有" => "420144542@qq.com" }
  
  spec.platform     = :ios, "13.0"

  spec.swift_version = '5.0'

  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

  spec.source       = { :git => "https://github.com/13662049573/TFYSwiftEmptyDataSet.git", :tag => spec.version }

  spec.source_files  = "TFYSwiftEmptyDataSet/TFYSwiftEmptyDataSetKit/*.{swift}"
  
  spec.requires_arc = true

end
