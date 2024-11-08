#
# Be sure to run `pod lib lint UrpayCards.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UrpayCards'
  s.version          = '0.5.4'
  s.summary          = 'A framework for handling Urpay cards in iOS applications.'
  s.description      = <<-DESC
    UrpayCards is a framework designed for iOS applications to handle card management.
  DESC
  s.homepage         = 'https://github.com/iAhmedWahdan/UrpayCards'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'iAhmedWahdan' => 'ahmednasrwahdan@gmail.com' }
  s.source           = { :git => 'https://github.com/iAhmedWahdan/UrpayCards.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '13.0'
  s.vendored_frameworks = 'UrpayCards.xcframework'
  s.swift_versions = ['5.0']

  # Exclude arm64 from the simulator to prevent architecture conflicts
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'ONLY_ACTIVE_ARCH' => 'NO',
    'ENABLE_BITCODE' => 'NO'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  # Use a resource bundle to package resources separately
  s.resource_bundles = {
    'UrpayCardsResources' => [
      'UrpayCards.xcframework/**/*.xcassets',
      'UrpayCards.xcframework/**/*.{xib,storyboard,png,jpg,svg,pdf,json}'
    ]
  } 

  # Expose source files conditionally for development or hide for production
  if ENV['DEV_POD'] == 'true'
    s.source_files = 'UrpayCards/**/*.{swift,xib,storyboard}'
  else
    s.source_files = [] # Empty for production to hide code
  end
end
