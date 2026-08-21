//
//  ProfileView.swift
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

struct ProfileView: View {
  @Binding var isPresented: Bool
  @ObservedObject var userViewModel: UserViewModel
  @State private var displayName = Auth.auth().currentUser?.displayName ?? ""

  var body: some View {
    NavigationView {
      VStack(spacing: 24) {
        VStack(spacing: 8) {
          Image(systemName: "person.circle.fill")
            .font(.system(size: 80))
            .foregroundColor(Color("FirebaseOrange"))
          Text(Auth.auth().currentUser?.email ?? "User Profile")
            .font(.subheadline)
            .foregroundColor(.gray)
        }
        .padding(.top, 32)

        VStack(alignment: .leading, spacing: 8) {
          Text("DISPLAY NAME")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.gray)

          HStack {
            Image(systemName: "person.fill")
              .foregroundColor(.gray)
            TextField("Display Name", text: $displayName)
              .autocorrectionDisabled()
          }
          .padding()
          .background(Color(.systemGray6))
          .cornerRadius(10)
        }
        .padding(.horizontal, 32)

        Button(action: {
          Task {
            await userViewModel.updateDisplayName(displayName)
            isPresented = false
          }
        }) {
          Text("UPDATE PROFILE")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("FirebaseOrange"))
            .cornerRadius(25)
        }
        .padding(.horizontal, 32)

        Spacer()
      }
      .navigationTitle("Profile")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") {
            isPresented = false
          }
        }
      }
    }
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(isPresented: .constant(true), userViewModel: UserViewModel())
  }
}
