source 'https://cdn.cocoapods.org/'
platform :ios, '15.0'

use_frameworks!

target "orderMe" do
  inhibit_all_warnings!

  pod 'Alamofire'
  pod 'ObjectMapper'
  pod 'AlamofireImage'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'SwiftLint'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'
  pod 'FBSDKPlacesKit'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        # Force Deployment Target for all pods to at least 15.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end
