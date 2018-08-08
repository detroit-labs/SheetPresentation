Pod::Spec.new do |s|

  s.name         = "BottomSheetPresentation"
  s.version      = "0.3.0"
  s.summary      = "A UIPresentationController for iOS to present a view controller pinned to the bottom of the screen."

  s.description  = <<-DESC
A UIPresentationController and attendant clases for iOS to present a view controller pinned to the bottom of the screen like an action sheet. Integrates with the UIKit view controller presentation hooks to involve as little integration surface as possible.
                   DESC

  s.homepage     = "https://github.com/detroit-labs/BottomSheetPresentation"

  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "Jeff Kelley" => "SlaunchaMan@gmail.com" }
  s.social_media_url   = "https://twitter.com/SlaunchaMan"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/Detroit-Labs/BottomSheetPresentation.git", :tag => "#{s.version}" }

  s.source_files  = "Code/*.swift"

  s.framework  = "UIKit"

  s.swift_version = "4.2"

end
