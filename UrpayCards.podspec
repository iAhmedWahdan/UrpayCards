#
# Be sure to run `pod lib lint UrpayCards.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UrpayCards'
  s.version          = '0.4.3'
  s.summary          = 'A framework for handling Urpay cards in iOS applications.'

  s.description      = <<-DESC
    UrpayCards is a framework designed for iOS applications to handle card management.
    It provides features such as card addition, deletion, and transaction management for Urpay services.
  DESC

  s.homepage         = 'https://github.com/iAhmedWahdan/UrpayCards'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'iAhmedWahdan' => 'ahmednasrwahdan@gmail.com' }
  s.source           = { :git => 'https://github.com/iAhmedWahdan/UrpayCards.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  # Use the compiled .xcframework for production builds
  s.vendored_frameworks = 'UrpayCards.xcframework'

  # Specify Swift version
  s.swift_versions = ['5.0']

  # Conditionally include source files and resources for local development
  if ENV['DEV_POD'] == 'true'
    # Development: expose all source files and resources
    s.source_files = 'UrpayCards/**/*.{swift,xib,storyboard}'
    s.resources = 'UrpayCards/**/*.{png,jpg,svg,pdf,xcassets,json}'
  else
    # Production: bundle resources in a separate bundle within the .xcframework
    s.resource_bundles = {
      'UrpayCardsResources' => [
        'UrpayCards/**/*.{xib,storyboard,png,jpg,svg,pdf,xcassets,json}'
      ]
    }
  end
end
