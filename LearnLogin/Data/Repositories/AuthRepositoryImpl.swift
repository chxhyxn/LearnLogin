//
//  AuthRepositoryImpl.swift
//  LearnLogin
//
//  Created by SeanCho on 3/15/25.
//

class AuthRepositoryImpl: AuthRepository {
    private let appleAuthDataSource: AppleAuthDataSource
    private let googleAuthDataSource: GoogleAuthDataSource
    private let kakaoAuthDataSource: KakaoAuthDataSource
    private var currentUser: User?
    
    init(
        appleAuthDataSource: AppleAuthDataSource,
        googleAuthDataSource: GoogleAuthDataSource,
        kakaoAuthDataSource: KakaoAuthDataSource
    ) {
        self.appleAuthDataSource = appleAuthDataSource
        self.googleAuthDataSource = googleAuthDataSource
        self.kakaoAuthDataSource = kakaoAuthDataSource
    }
    
    func signInWithApple() async throws -> User {
        let userDTO = try await appleAuthDataSource.signIn()
        let user = userDTO.toDomain()
        currentUser = user
        return user
    }
    
    func signInWithGoogle() async throws -> User {
        let userDTO = try await googleAuthDataSource.signIn()
        let user = userDTO.toDomain()
        currentUser = user
        return user
    }
    
    func signInWithKakao() async throws -> User {
        let userDTO = try await kakaoAuthDataSource.signIn()
        let user = userDTO.toDomain()
        currentUser = user
        return user
    }
    
    func signOut() async throws {
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
}
