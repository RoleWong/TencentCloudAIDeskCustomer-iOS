#
# Be sure to run `pod lib lint TencentCloudAIDeskCustomer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TencentCloudAIDeskCustomer'
  s.version          = '1.0.13'
  s.summary          = 'AI-driven customer service UIKit for Tencent Cloud Desk (customer-side).'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!


  s.description      = 'Tencent Cloud Desk Customer UIKit is a UIKit for integrating AI-powered customer service chat on the customer side of Tencent Cloud Desk, providing efficient and seamless communication with both AI and human agents.'

  s.homepage         = 'https://desk.qcloud.com/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tencent Cloud Desk' => '814209329@qq.com' }
  s.swift_version = '5.0'
  s.source           = { :git => 'https://github.com/RoleWong/TencentCloudAIDeskCustomer-iOS', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  
#  s.vendored_frameworks = 'OpenTelemetry.framework'
  
  s.dependency 'TDeskCore', '~> 2.9.013'
  s.dependency 'TDeskCommon', '~> 2.9.013'
  s.dependency 'TDeskChat', '~> 2.9.013'
  s.dependency 'TDeskCustomerServicePlugin', '~>2.9.013'
  
  s.frameworks = 'UIKit', 'Foundation'
  s.source_files = ['TencentCloudAIDeskCustomer/Classes/**/*', 'OpenTelemetry/Classes/**/*']
  s.public_header_files = ['TencentCloudAIDeskCustomer/Classes/**/*.h', 'OpenTelemetry/Classes/**/*.h']
#  s.source_files = 'TencentCloudAIDeskCustomer/Classes/**/*'
#  s.public_header_files = 'TencentCloudAIDeskCustomer/Classes/**/*.h'
  
  s.resource = ['Resources/*.bundle']
  

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
