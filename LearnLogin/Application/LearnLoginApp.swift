//
//  LearnLoginApp.swift
//  LearnLogin
//
//  Created by SeanCho on 3/15/25.
//

import SwiftUI
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct LearnLoginApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // 구글 로그인 처리
                    if GIDSignIn.sharedInstance.handle(url) {
                        return
                    }
                    
                    // 카카오 로그인 처리
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // 카카오 SDK 초기화
        KakaoSDK.initSDK(appKey: "YOUR_KAKAO_APP_KEY")
        
        return true
    }
}
