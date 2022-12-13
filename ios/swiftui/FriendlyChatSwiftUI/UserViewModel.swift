//
//  UserViewModel.swift
//  FriendlyChatSwiftUI
//
//  Copyright (c) 2022 Google Inc.
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

class UserViewModel: ObservableObject {
  @AppStorage("isSignedIn") var isSignedIn = false
  @Published var email = ""
  @Published var password = ""
  @Published var displayName = ""
  @Published var alert = false
  @Published var alertMessage = ""

  private func showAlertMessage(message: String) {
    alertMessage = message
    alert.toggle()
  }

  func login() {
    // check if all fields are inputted correctly
    if email.isEmpty || password.isEmpty {
      showAlertMessage(message: "Neither email nor password can be empty.")
      return
    }
    // Sign in with email and password
    Auth.auth().signIn(withEmail: email, password: password) { result, err in
      if let err = err {
        self.alertMessage = err.localizedDescription
        self.alert.toggle()
      } else {
        self.isSignedIn = true
      }
    }
  }

  func signUp() {
    // Check if all fields are inputted correctly
    if email.isEmpty || password.isEmpty {
      showAlertMessage(message: "Neither email nor password can be empty.")
      return
    }
    // Sign up with email and password
    Auth.auth().createUser(withEmail: email, password: password) { result, err in
      if let err = err {
        self.alertMessage = err.localizedDescription
        self.alert.toggle()
      } else {
        self.login()
      }
    }
  }

  func updateDisplayName() {
    print("signing up user and setting display name to: \(self.displayName)")
    // On creation of new user, set display name
    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
    changeRequest.displayName = self.displayName
    changeRequest.commitChanges { error in
      if let error = error {
        print("got some sort of error in display name")
        self.alertMessage = error.localizedDescription
        self.alert.toggle()
      } else {
        print("display was supposedly a success...")
      }
    }
  }

  func logout() {
    do {
      try Auth.auth().signOut()
      isSignedIn = false
      email = ""
      password = ""
    } catch {
      print("Error signing out: \(error)")
    }
  }
}

let user = UserViewModel()
