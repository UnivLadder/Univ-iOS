# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'UnivLadder' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for UnivLadder
  pod 'MultiSlider'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  pod 'GoogleSignIn'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxRelay'
  pod 'SnapKit'
  pod 'Then'
  pod 'Cosmos', '~> 23.0'
  pod 'KakaoSDKCommon'  # 필수 요소를 담은 공통 모듈
  pod 'KakaoSDKAuth'  # 카카오 로그인
  pod 'KakaoSDKUser' # 카카오 로그인, 사용자 관리

  target 'UnivLadderTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'UnivLadderUITests' do
    # Pods for testing
  end

end



post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
