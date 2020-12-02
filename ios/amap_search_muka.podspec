#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint amap_search.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'amap_search_muka'
  s.version          = '0.0.1'
  s.summary          = 'Flutter amap_search_muka'
  s.description      = <<-DESC
Flutter amap_search
                       DESC
  s.homepage         = 'https://github.com/Spicely/amap_view/tree/search'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Spicey' => 'Spicely@outlook.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true
  s.dependency 'Flutter'
  s.dependency 'AMapSearch'
  s.dependency 'AMapNavi'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
