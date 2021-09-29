# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'cloud_offline' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for cloud_offline
  pod 'GoogleSignIn', '~> 6.0.1'
  pod 'GoogleAPIClientForREST/Drive', '~> 1.3.7'
  pod 'RealmSwift'
  pod 'Tabman', '~> 2.11'
  pod 'SCLAlertView'
  pod "EVTopTabBar"

end
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
