//
//  AuthRepositoryImpl.swift
//  LearnLogin
//
//  Created by SeanCho on 3/15/25.
//

import OSLog

class AuthRepositoryImpl: AuthRepository {
    private let appleAuthDataSource: AppleAuthDataSource
    private let googleAuthDataSource: GoogleAuthDataSource
    private let kakaoAuthDataSource: KakaoAuthDataSource
    private let firestoreDataSource: UserFirestoreDataSource
    private var currentUser: User?
    private let logger = Logger(subsystem: "com.yourapp.LearnLogin", category: "AuthRepository")
    
    init(
        appleAuthDataSource: AppleAuthDataSource,
        googleAuthDataSource: GoogleAuthDataSource,
        kakaoAuthDataSource: KakaoAuthDataSource,
        firestoreDataSource: UserFirestoreDataSource
    ) {
        self.appleAuthDataSource = appleAuthDataSource
        self.googleAuthDataSource = googleAuthDataSource
        self.kakaoAuthDataSource = kakaoAuthDataSource
        self.firestoreDataSource = firestoreDataSource
    }
    
    func signInWithApple() async throws -> User {
        logger.info("Signing in with Apple")
        let userDTO = try await appleAuthDataSource.signIn()
        
        // Firestore에 사용자 데이터 저장
        try await firestoreDataSource.saveUser(userDTO)
        
        let user = userDTO.toDomain()
        currentUser = user
        return user
    }
    
    func signInWithGoogle() async throws -> User {
        logger.info("Signing in with Google")
        let userDTO = try await googleAuthDataSource.signIn()
        
        // Firestore에 사용자 데이터 저장
        try await firestoreDataSource.saveUser(userDTO)
        
        let user = userDTO.toDomain()
        currentUser = user
        return user
    }
    
    func signInWithKakao() async throws -> User {
        logger.info("Signing in with Kakao")
        let userDTO = try await kakaoAuthDataSource.signIn()
        
        // Firestore에 사용자 데이터 저장
        try await firestoreDataSource.saveUser(userDTO)
        
        let user = userDTO.toDomain()
        currentUser = user
        return user
    }
    
    func signOut() async throws {
        logger.info("Signing out user")
        // 현재 로그인된 제공자에 따라 로그아웃
        if let user = currentUser {
            switch user.provider {
            case .google:
                googleAuthDataSource.signOut()
            case .kakao:
                try await kakaoAuthDataSource.signOut()
            case .apple:
                // Apple은 별도의 로그아웃 처리가 필요 없음
                break
            }
        }
        currentUser = nil
    }
    
    func getCurrentUser() async -> User? {
        return currentUser
    }
    
    // Firestore에서 사용자 프로필 정보 업데이트
    func updateUserProfile(userId: String, name: String?, profileImageUrl: String?) async throws {
        logger.info("Updating user profile for \(userId)")
        var updateData: [String: Any] = [:]
        
        if let name = name {
            updateData["name"] = name
        }
        
        if let profileImageUrl = profileImageUrl {
            updateData["profileImageUrl"] = profileImageUrl
        }
        
        if !updateData.isEmpty {
            try await firestoreDataSource.updateUserInfo(id: userId, additionalInfo: updateData)
            
            // 현재 사용자 객체도 업데이트
            if var user = currentUser, user.id == userId {
                if let name = name {
                    user = User(
                        id: user.id,
                        name: name,
                        email: user.email,
                        profileImageUrl: user.profileImageUrl,
                        provider: user.provider
                    )
                }
                currentUser = user
            }
        }
    }
}
