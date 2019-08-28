Pod::Spec.new do |s|

s.name         = "AACycleScrollView"
s.version      = "2.0.4"
s.summary      = "iOS 自动轮播图"

s.homepage     = "https://github.com/Fxxxxxx/AACycleScrollView"
#s.screenshots  = ""

s.license      = { :type => "MIT", :file => "LICENSE" }

s.authors            = { "Aaron Feng" => "e2shao1993@163.com" }

s.swift_version = "5"

s.ios.deployment_target = "8.0"

s.source       = { :git => "https://github.com/Fxxxxxx/AACycleScrollView.git", :tag => s.version }

s.source_files  = "AACycleScrollView/*"

s.requires_arc = true
s.framework = "UIKit"
s.dependency   'Kingfisher'

end
