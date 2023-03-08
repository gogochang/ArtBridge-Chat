# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ArtBridge' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ArtBridge

  pod 'Alamofire'

  # Add the Firebase pod for Google Analytics
  pod 'FirebaseAnalytics'

  # For Analytics without IDFA collection capability, use this pod instead
  # pod ‘Firebase/AnalyticsWithoutAdIdSupport’

  # Add the pods for any other Firebase products you want to use in your app
  # For example, to use Firebase Authentication and Cloud Firestore
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseStorage'

  pod 'Firebase'
  pod 'Firebase/Database'

  # for Kakao
  pod 'KakaoSDKCommon' # 카카오 필수 요소를 담은 공통 모듈
  pod 'KakaoSDKAuth' # 카카오 사용자인증
  pod 'KakaoSDKUser' # 카카오 로그인, 사용자 관리

  # for Google Login
  pod 'GoogleSignIn' # 구글 로그인

  target 'ArtBridgeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ArtBridgeUITests' do
    # Pods for testing
  end

end
