#
# Be sure to run `pod lib lint SeedSegmentedView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SeedSegmentedView'
  s.version          = '1.0.0'
  s.summary          = '分页标签控件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
一个父视图控制器和多个子视图控制器
                       DESC

  s.homepage         = 'https://github.com/GuanQinghao/SeedSegmentedView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'GuanQinghao' => 'qinghaoguan@163.com' }
  s.source           = { :git => 'https://github.com/GuanQinghao/SeedSegmentedView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'SeedSegmentedView/Classes/**/*'
  s.public_header_files = 'Pod/Classes/SeedSegmentedView.h'
  
  # s.resource_bundles = {
  #   'SeedSegmentedView' => ['SeedSegmentedView/Assets/*.png']
  # }
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
end
