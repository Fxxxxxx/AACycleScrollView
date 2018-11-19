Pod::Spec.new do |s|

s.name         = "AACycleScrollView"
s.version      = "1.0"
s.summary      = "iOS 自动轮播图"

s.homepage     = "https://github.com/Fxxxxxx/AACycleScrollView"
#s.screenshots  = ""

s.license      = { :type => "MIT", :file => "LICENSE" }

s.authors            = { "Aaron Feng" => "e2shao1993@163.com" }

s.swift_version = "4.2"

s.ios.deployment_target = "7.0"

s.source       = { :git => "https://github.com/Fxxxxxx/AACycleScrollView.git", :tag => s.version }

s.source_files  = "AACycleScrollView/*.swift"

s.requires_arc = true
s.framework = "UIKit"

end
