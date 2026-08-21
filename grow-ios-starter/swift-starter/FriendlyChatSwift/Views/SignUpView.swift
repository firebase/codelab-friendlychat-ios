//
//  SignUpView.swift
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

struct SignUpView: View {
  @Bindable var userViewModel: UserViewModel
  @Binding var isPresented: Bool

  @State private var email = ""
  @State private var password = ""
  @State private var displayName = ""

  var body: some View {
    VStack(spacing: 24) {
      Text("CREATE ACCOUNT")
        .font(.title2)
        .fontWeight(.bold)
        .foregroundStyle(Color("FirebaseOrange"))
        .padding(.top, 24)

      VStack(spacing: 16) {
        HStack {
          Image(systemName: "person.fill")
            .foregroundStyle(.gray)
          TextField("Display Name", text: $displayName)
            .autocorrectionDisabled()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 10))

        HStack {
          Image(systemName: "envelope.fill")
            .foregroundStyle(.gray)
          TextField("Email", text: $email)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 10))

        HStack {
          Image(systemName: "lock.fill")
            .foregroundStyle(.gray)
          SecureField("Password", text: $password)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 10))
      }
      .padding(.horizontal, 32)

      Button(action: {
        Task {
          await userViewModel.signUp(email: email, password: password, displayName: displayName)
          if userViewModel.user != nil {
            isPresented = false
          }
        }
      }) {
        Text("SIGN UP")
          .font(.headline)
          .foregroundStyle(.white)
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color("FirebaseOrange"))
          .clipShape(Capsule())
      }
      .padding(.horizontal, 32)

      HStack {
        Text("Already have an account?")
        Button("Login") {
          isPresented = false
        }
        .fontWeight(.bold)
        .foregroundStyle(Color("FirebaseOrange"))
      }

      Spacer()
    }
    .alert("Notice", isPresented: $userViewModel.showAlert) {
      Button("OK", role: .cancel) { }
    } message: {
      Text(userViewModel.errorMessage ?? "")
    }
  }
}

#Preview {
  SignUpView(userViewModel: UserViewModel(), isPresented: .constant(true))
}
