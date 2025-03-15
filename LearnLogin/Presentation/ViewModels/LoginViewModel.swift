//
//  LoginViewModel.swift
//  LearnLogin
//
//  Created by SeanCho on 3/15/25.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    private let authUseCase: AuthUseCase
    
    @Published var isLoading = false
    @Published var error: String?
    @Published var user: User?
    @Published var isAuthenticated = false
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
        Task {
            await checkCurrentUser()
        }
    }
    
    func checkCurrentUser() async {
        Task {
            await MainActor.run {
                isLoading = true
            }
            
            if let user = await authUseCase.getCurrentUser() {
                await MainActor.run {
                    self.user = user
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            }else {
                await MainActor.run {
                    self.user = nil
                    self.isAuthenticated = false
                    self.isLoading = false
                }
            }
        }
    }
    
    func signInWithApple() {
        signIn {
            try await self.authUseCase.signInWithApple()
        }
    }
    
    func signInWithGoogle() {
        signIn {
            try await self.authUseCase.signInWithGoogle()
        }
    }
    
    func signInWithKakao() {
        signIn {
            try await self.authUseCase.signInWithKakao()
        }
    }
    
    private func signIn(authMethod: @escaping () async throws -> User) {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.error = nil
            }
            
            do {
                let user = try await authMethod()
                await MainActor.run {
                    self.user = user
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
