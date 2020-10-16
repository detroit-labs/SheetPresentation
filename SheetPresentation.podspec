Pod::Spec.new do |s|

  s.name         = "SheetPresentation"
  s.version      = "1.0.0.rc.1"
  s.summary      = "A UIPresentationController for iOS to present a view controller pinned to the bottom of the screen."

  s.description  = <<-DESC
A UIPresentationController and attendant classes for iOS to present a view controller pinned to the bottom of the screen like an action sheet. Integrates with the UIKit view controller presentation hooks to involve as little integration surface as possible.
                   DESC

  s.homepage     = "https://github.com/detroit-labs/BottomSheetPresentation"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Jeff Kelley" => "SlaunchaMan@gmail.com" }
  s.social_media_url   = "https://twitter.com/SlaunchaMan"

  s.platform     = :ios, '10'

  s.source       = {
    :git => "https://github.com/Detroit-Labs/SheetPresentation.git",
    :tag => "#{s.version}"
  }

  s.source_files  = "Sources/**/*.{swift,h}"

  s.framework  = "UIKit"

  s.swift_versions = ['4', '4.2', '5', '5.1', '5.2', '5.3']

  s.test_spec 'SheetPresentationTests' do |ts|
    ts.platform = :ios, '10'
    ts.source_files = 'Tests/**/*.swift'
  end

end
