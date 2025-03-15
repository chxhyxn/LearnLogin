#Apple 로그인 설정

1. Apple Developer 계정에서 "Certificates, Identifiers & Profiles" 섹션
2. Identifiers에서 앱 ID를 선택하고 "Sign In with Apple" 기능을 활성화
3. 프로젝트의 Signing & Capabilities 탭에서 "Sign In with Apple" 기능을 추가

#Google 로그인 설정
1. Google Cloud Console에서 새 프로젝트를 생성합니다.
2. "API 및 서비스" > "사용자 인증 정보"로 이동합니다.
3. "사용자 인증 정보 만들기" > "OAuth 클라이언트 ID"를 선택합니다.
4. 애플리케이션 유형으로 "iOS"를 선택하고 번들 ID를 입력합니다.
5. 생성된 클라이언트 ID를 Info.plist의 GIDClientID 키에 추가합니다.
6. URL 스키마(com.googleusercontent.apps.YOUR_CLIENT_ID)도 Info.plist에 추가합니다.
