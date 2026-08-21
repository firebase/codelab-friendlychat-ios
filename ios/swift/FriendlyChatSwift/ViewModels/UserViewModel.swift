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
import Observation
import FirebaseAuth

@MainActor
@Observable
final class UserViewModel {
  var user: User?
  var errorMessage: String?
  var showAlert = false

  @ObservationIgnored
  private var authStateHandle: AuthStateDidChangeListenerHandle?

  init() {
    authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
      self?.user = user
    }
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
    do {
      try await Auth.auth().signIn(withEmail: email, password: password)
    } catch {
      showError(error.localizedDescription)
    }
  }

  func signUp(email: String, password: String, displayName: String) async {
    errorMessage = nil
    if email.isEmpty || password.isEmpty {
      showError("Please enter both email and password.")
      return
    }
    do {
      let result = try await Auth.auth().createUser(withEmail: email, password: password)
      let changeRequest = result.user.createProfileChangeRequest()
      changeRequest.displayName = displayName.isEmpty ? email : displayName
      try await changeRequest.commitChanges()
      self.user = Auth.auth().currentUser
    } catch {
      showError(error.localizedDescription)
    }
  }

  func updateDisplayName(_ displayName: String) async {
    guard let currentUser = Auth.auth().currentUser else { return }
    do {
      let changeRequest = currentUser.createProfileChangeRequest()
      changeRequest.displayName = displayName
      try await changeRequest.commitChanges()
      self.user = Auth.auth().currentUser
    } catch {
      showError(error.localizedDescription)
    }
  }

  func signOut() {
    do {
      try Auth.auth().signOut()
    } catch {
      showError(error.localizedDescription)
    }
  }

  private func showError(_ message: String) {
    errorMessage = message
    showAlert = true
  }
}
