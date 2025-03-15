//
//  GoogleAuthDataSource.swift
//  LearnLogin
//
//  Created by SeanCho on 3/15/25.
//

import GoogleSignIn

class GoogleAuthDataSource {
    func signIn() async throws -> UserDTO {
        return try await withCheckedThrowingContinuation { continuation in
            guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
                continuation.resume(throwing: NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "No root view controller found"]))
                return
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let user = result?.user,
                      let userId = user.userID,
                      let profile = user.profile else {
                    continuation.resume(throwing: NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing user data"]))
                    return
                }
                
                let userDTO = UserDTO(
                    id: userId,
                    name: profile.name,
                    email: profile.email,
                    profileImageUrl: profile.imageURL(withDimension: 100)?.absoluteString,
                    provider: "google"
                )
                
                continuation.resume(returning: userDTO)
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
