#
# Be sure to run `pod lib lint SeedSegmentedControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'SeedSegmentedControl'
    s.version          = '1.1.1'
    s.summary          = '分段标签控件'
    s.homepage         = 'https://github.com/GuanQinghao/SeedSegmentedControl'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'GuanQinghao' => 'qinghaoguan@163.com' }
    s.source           = { :git => 'https://github.com/GuanQinghao/SeedSegmentedControl.git', :tag => s.version.to_s }
    s.ios.deployment_target = '11.0'
    
    s.source_files = 'SeedSegmentedControl/SeedSegmentedControl.h'
    
    s.subspec 'SeedSegmentedTitleView' do |ss|
        ss.source_files = 'SeedSegmentedControl/SeedSegmentedTitleView/**/*'
    end
    
    s.subspec 'SeedSegmentedContentView' do |ss|
        ss.source_files = 'SeedSegmentedControl/SeedSegmentedContentView/**/*'
    end
    
    s.subspec 'SeedSegmentedCategory' do |ss|
        ss.source_files = 'SeedSegmentedControl/SeedSegmentedCategory/**/*'
    end
    
end
