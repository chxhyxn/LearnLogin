//
//  KakaoAuthDataSource.swift
//  LearnLogin
//
//  Created by SeanCho on 3/15/25.
//

import KakaoSDKAuth
import KakaoSDKUser
import SwiftUI

class KakaoAuthDataSource {
    func signIn() async throws -> UserDTO {
        return try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    self.getUserInfo { result in
                        switch result {
                        case .success(let userDTO):
                            continuation.resume(returning: userDTO)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    self.getUserInfo { result in
                        switch result {
                        case .success(let userDTO):
                            continuation.resume(returning: userDTO)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
        }
    }
    
    func signOut() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.logout { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    private func getUserInfo(completion: @escaping (Result<UserDTO, Error>) -> Void) {
        UserApi.shared.me { user, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = user,
                  let id = user.id else {
                completion(.failure(NSError(domain: "KakaoAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing user data"])))
                return
            }
            
            let name = user.properties?["nickname"] ?? "Kakao User"
            let email = user.kakaoAccount?.email
            let profileImageUrl = user.properties?["profile_image"]
            
            let userDTO = UserDTO(
                id: "\(id)",
                name: name,
                email: email,
                profileImageUrl: profileImageUrl,
                provider: "kakao"
            )
            
            completion(.success(userDTO))
        }
    }
}
