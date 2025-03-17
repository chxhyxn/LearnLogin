# 소셜 로그인

### Apple 로그인 설정

1. Apple Developer 계정에서 "Certificates, Identifiers & Profiles" 섹션
2. Identifiers에서 앱 ID를 선택하고 "Sign In with Apple" 기능을 활성화
3. 프로젝트의 Signing & Capabilities 탭에서 "Sign In with Apple" 기능을 추가

### Google 로그인 설정
1. Google Cloud Console에서 새 프로젝트를 생성 ([https://console.cloud.google.com/](https://console.cloud.google.com/))
2. "API 및 서비스" > "사용자 인증 정보"로 이동
3. "사용자 인증 정보 만들기" > "OAuth 클라이언트 ID"를 선택
4. 애플리케이션 유형으로 "iOS"를 선택하고 번들 ID를 입력
5. 생성된 CLIENT_ID를 Info.plist의 GIDClientID 키에 추가
6. URL 스키마(REVERSED_CLIENT_ID)도 Info.plist에 추가
7. SPM에서 URL : "[https://github.com/google/GoogleSignIn-iOS](https://github.com/google/GoogleSignIn-iOS)" 입력 후 GoogleSignIn, GoogleSignInSwift 추가

## 카카오 로그인 설정
1. Kakao Developers 상단 메뉴에서 "내 애플리케이션" > "애플리케이션 추가하기" ([https://developers.kakao.com/console/app](https://developers.kakao.com/console/app))
2. 앱 이름과 회사명을 입력하고 "저장"
3. 생성된 앱 페이지에서 "앱 키"에서 "네이티브 앱 키" 확인
4. 왼쪽 메뉴에서 "플랫폼" > "iOS 플랫폼 등록"
5. 앱의 번들 ID를 정확히 입력합니다(예: com.yourcompany.SocialAuthApp). 앱스토어 ID는 앱이 스토어에 등록되지 않은 경우 비워둬도 됩니다.
6. 왼쪽 메뉴에서 "카카오 로그인"을 클릭
7. "활성화 설정" 상태를 "ON"으로 변경
8. "OpenID Connect 활성화 설정"을 "사용함"으로 설정하면 ID 토큰을 받을 수 있습니다(권장).
10. "동의항목" 탭에서 "필수 동의항목"과 "선택 동의항목"을 앱에 필요한 대로 설정. 기본적으로 프로필 정보(닉네임, 프로필 사진)는 필수 항목이며, 이메일 등은 선택 항목으로 설정할 수 있습니다.
11. Info.plist에 URL Scheme을 추가합니다: "kakao" + 네이티브 앱 키 (예: kakao1234567890abcdef)
12. AppDelegate.swift 파일에 다음과 같이 코드를 추가

        import KakaoSDKCommon

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // 카카오 SDK 초기화
            KakaoSDK.initSDK(appKey: "YOUR_NATIVE_APP_KEY")
    
            return true
        }

13. Info.plist에 다음 항목을 추가
    
        <key>LSApplicationQueriesSchemes</key>
        <array>
            <string>kakaokompassauth</string>
            <string>kakaolink</string>
            <string>kakaoplus</string>
            <string>kakaotalk</string>
        </array>
14. SPM에서 URL : "[https://github.com/google/GoogleSignIn-iOS](https://github.com/kakao/kakao-ios-sdk)" 입력 후 KakaoSDKUser, KakaoSDKAuth 추가

## 최종 Info.plist

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    	<key>GIDClientID</key>
    	<string>구글 클라이언트 아이디</string>
    	<key>CFBundleURLTypes</key>
    	<array>
    		<dict>
    			<key>CFBundleTypeRole</key>
    			<string>Editor</string>
    			<key>CFBundleURLSchemes</key>
    			<array>
    				<string>reversed 구글 클라이언트 아이디</string>
    				<string>kakao+카카오앱키</string>
    			</array>
    		</dict>
    	</array>
        <key>LSApplicationQueriesSchemes</key>
        <array>
            <string>kakaokompassauth</string>
            <string>kakaolink</string>
            <string>kakaoplus</string>
            <string>kakaotalk</string>
        </array>
    </dict>
    </plist>

# 유저 데이터베이스 구성 Firestore
1. SPM에서 URL : "[https://github.com/firebase/firebase-ios-sdk.git](https://github.com/firebase/firebase-ios-sdk.git)" 입력 후 FirebaseFirestore, FirebaseAuth, FirebaseAnalyticsWithoutAdId 추가
2. firebase console에서 프로젝트 등록.
3. GoogleService-Info.plist 프로젝트에 추가.
4. firestore database 생성
