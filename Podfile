source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

use_frameworks!

target "orderMe" do
   inhibit_all_warnings!
	pod 'Alamofire', '~> 4.9.1'
	pod 'ObjectMapper'
	pod 'AlamofireImage', '~> 3.6.0'
	pod 'FacebookCore'
	pod 'FacebookLogin'
	pod 'FacebookShare'
	pod 'Fabric'
	pod 'Crashlytics'
	pod 'SwiftLint'
	pod 'FBSDKCoreKit'  
	pod 'FBSDKLoginKit'
	pod 'FBSDKShareKit'
	pod 'FBSDKPlacesKit'
  pod 'SBTUITestTunnelServer', '~> 8.2.0'
  pod 'GCDWebServer', :inhibit_warnings => true

target 'OrderMEUITests' do
	pod 'SBTUITestTunnelClient', '~> 8.2.0'

  post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          # Force CocoaPods targets to always build for x86_64
          config.build_settings['ARCHS[sdk=iphonesimulator*]'] = 'x86_64'
        end
  end
end
end
end