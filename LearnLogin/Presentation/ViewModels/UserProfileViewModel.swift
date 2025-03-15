//
//  UserProfileViewModel.swift
//  LearnLogin
//
//  Created by SeanCho on 3/15/25.
//

import SwiftUI
import Combine

class UserProfileViewModel: ObservableObject {
    private let authUseCase: AuthUseCase
    
    @Published var user: User?
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
        Task {
            await loadUser()
        }
    }
    
    private func loadUser() async {
        if let user = await authUseCase.getCurrentUser() {
            await MainActor.run {
                self.user = user
            }
        }
    }
    
    func signOut(completion: @escaping () -> Void) {
        Task {
            do {
                try await authUseCase.signOut()
                await MainActor.run {
                    completion()
                }
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
    }
}
