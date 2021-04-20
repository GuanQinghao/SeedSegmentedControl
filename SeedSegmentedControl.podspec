#
# Be sure to run `pod lib lint SeedSegmentedControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SeedSegmentedControl'
  s.version          = '1.1.0'
  s.summary          = '分段标签控件'
  s.homepage         = 'https://github.com/GuanQinghao/SeedSegmentedControl'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'GuanQinghao' => 'qinghaoguan@163.com' }
  s.source           = { :git => 'https://github.com/GuanQinghao/SeedSegmentedControl.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'SeedSegmentedControl/Classes/**/*'
  s.public_header_files = 'Pod/Classes/SeedSegmentedControl.h'
end
