# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

target 'bankcard' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for bankcard
  pod 'AnyThinkiOS','6.2.82'
  pod 'AnyThinkiOS/AnyThinkBaiduAdapter','6.2.82'
  pod 'AnyThinkiOS/AnyThinkKuaiShouAdapter','6.2.82'
  pod 'AnyThinkiOS/AnyThinkGDTAdapter','6.2.82'
  pod 'CSJMBaiduAdapter', '5.325.2'
  pod 'Ads-Fusion-CN-Beta','5.8.1.0', :subspecs => ['BUAdSDK', 'CSJMediation']

  post_install do |installer|
       installer.generated_projects.each do |project|
         project.targets.each do |target|
           target.build_configurations.each do |config|
             config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
           end
         end
       end
     end

end
