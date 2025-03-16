//
//  UserProfileViewModel.swift
//  LearnLogin
//
//  Created by SeanCho on 3/15/25.
//

import SwiftUI
import Combine
import OSLog

class UserProfileViewModel: ObservableObject {
    private let authUseCase: AuthUseCase
    private let logger = Logger(subsystem: "com.yourapp.LearnLogin", category: "UserProfileViewModel")
    
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
        Task {
            await loadUser()
        }
    }
    
    private func loadUser() async {
        await MainActor.run {
            isLoading = true
        }
        
        if let user = await authUseCase.getCurrentUser() {
            await MainActor.run {
                self.user = user
                self.isLoading = false
            }
        } else {
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    func updateProfile(name: String?) async {
        guard let user = user else { return }
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
            successMessage = nil
        }
        
        do {
            try await authUseCase.updateUserProfile(
                userId: user.id,
                name: name,
                profileImageUrl: nil
            )
            
            // 사용자 정보를 다시 로드합니다
            await loadUser()
            
            await MainActor.run {
                successMessage = "프로필이 성공적으로 업데이트되었습니다"
                isLoading = false
            }
        } catch {
            logger.error("프로필 업데이트 실패: \(error.localizedDescription)")
            
            await MainActor.run {
                errorMessage = "프로필 업데이트 실패: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    func signOut(completion: @escaping () -> Void) {
        Task {
            await MainActor.run {
                isLoading = true
            }
            
            do {
                try await authUseCase.signOut()
                await MainActor.run {
                    isLoading = false
                    completion()
                }
            } catch {
                logger.error("로그아웃 실패: \(error.localizedDescription)")
                
                await MainActor.run {
                    errorMessage = "로그아웃 실패: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
}
