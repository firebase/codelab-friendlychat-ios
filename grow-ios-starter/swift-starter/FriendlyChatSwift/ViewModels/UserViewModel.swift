//
//  UserViewModel.swift
//  FriendlyChatSwift
//
//  Copyright (c) 2026 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import SwiftUI
import FirebaseAuth

@MainActor
class UserViewModel: ObservableObject {
  @Published var user: User?
  @Published var errorMessage: String?
  @Published var showAlert = false

  private var authStateHandle: AuthStateDidChangeListenerHandle?

  init() {
    // TODO: Register Auth state change listener
  }

  deinit {
    if let handle = authStateHandle {
      Auth.auth().removeStateDidChangeListener(handle)
    }
  }

  func signIn(email: String, password: String) async {
    errorMessage = nil
    if email.isEmpty || password.isEmpty {
      showError("Please enter both email and password.")
      return
    }
    // TODO: Sign in with email and password using Auth.auth().signIn(withEmail:password:)
  }

  func signUp(email: String, password: String, displayName: String) async {
    errorMessage = nil
    if email.isEmpty || password.isEmpty {
      showError("Please enter both email and password.")
      return
    }
    // TODO: Create account and update profile displayName
  }

  func updateDisplayName(_ displayName: String) async {
    // TODO: Update current user profile displayName
  }

  func signOut() {
    // TODO: Sign out using Auth.auth().signOut()
  }

  private func showError(_ message: String) {
    errorMessage = message
    showAlert = true
  }
}
