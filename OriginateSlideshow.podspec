Pod::Spec.new do |s|
  s.name             = "OriginateSlideshow"
  s.version          = "0.0.1"
  s.summary          = "A customizable slideshow view controller."
  s.homepage         = "https://github.com/Originate/OriginateSlideshow"
  s.license          = 'MIT'
  s.author           = { "Allen Wu" => "allen.wu@originate.com" }
  s.source           = { :git => "https://github.com/Originate/OriginateSlideshow.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'

  s.frameworks = 'UIKit'
end
