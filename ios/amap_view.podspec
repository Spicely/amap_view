#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint amap_view.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'amap_view'
  s.version          = '0.0.1'
  s.summary          = '高德地图 地图插件'
  s.description      = <<-DESC
高德地图 地图插件
                       DESC
  s.homepage         = 'https://github.com/Spicely'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Spicely' => 'Spicely@outlook.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'AMapNavi'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
  s.static_framework = true
end
