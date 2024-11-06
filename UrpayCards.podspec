#
# Be sure to run `pod lib lint UrpayCards.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UrpayCards'
  s.version          = '0.5.1'
  s.summary          = 'A framework for handling Urpay cards in iOS applications.'
  s.description      = <<-DESC
  UrpayCards is a framework designed for iOS applications to handle card management.
  DESC
  s.homepage         = 'https://github.com/iAhmedWahdan/UrpayCards'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'iAhmedWahdan' => 'ahmednasrwahdan@gmail.com' }
  s.source           = { :git => 'https://github.com/iAhmedWahdan/UrpayCards.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '13.0'
  s.vendored_frameworks = 'build/UrpayCards.framework'
  s.swift_versions = ['5.0']

  # Configure build settings to exclude arm64 for the simulator and other potential conflicts
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'ONLY_ACTIVE_ARCH' => 'NO',
    'ENABLE_BITCODE' => 'NO'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  # Development: expose source files and resources
  if ENV['DEV_POD'] == 'true'
    s.source_files = 'UrpayCards/**/*.{swift,xib,storyboard}'
    s.resources = 'UrpayCards/**/*.{png,jpg,svg,pdf,xcassets,json}'
  else
    # Production: bundle resources in separate bundle
    s.resources = 'UrpayCards/**/*.{xib,storyboard,png,jpg,svg,pdf,xcassets,json}'
  end
end

