//
//  AuthRepository.swift
//  LearnLogin
//
//  Created by SeanCho on 3/15/25.
//

import SwiftUI

protocol AuthRepository {
    func signInWithApple() async throws -> User
    func signInWithGoogle() async throws -> User
    func signInWithKakao() async throws -> User
    func signOut() async throws
    func getCurrentUser() async -> User?
}
