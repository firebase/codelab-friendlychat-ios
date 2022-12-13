//
//  ProfileView.swift
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

struct ProfileView: View {
  @Binding var isPresented: Bool
  @ObservedObject var user: UserViewModel
  var screenHeight = UIScreen.main.bounds.size.height
  var screenWidth = UIScreen.main.bounds.size.width

  var body: some View {
    VStack {
      // Display name textfield
      HStack {
        Image("user-icon")
          .resizable()
          .scaledToFit()
          .frame(width: 30.0, height: 30.0)
          .opacity(0.5)
        TextField("Display Name (Optional)", text: $user.displayName)
          .keyboardType(.default)
          .autocapitalization(UITextAutocapitalizationType.words)
      }
      .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
      .padding(0.02 * screenHeight)
      .frame(width: screenWidth * 0.8)

      // Update profile button
      Button(action: {
        user.updateDisplayName()
        isPresented = false
      }) {
        Text("Update".uppercased())
          .foregroundColor(.white)
          .font(.title2)
          .bold()
          .padding(0.01 * screenHeight)
      }
      .background(Capsule().fill(Color("FirebaseOrange")))
      .buttonStyle(BorderlessButtonStyle())

      Spacer()
        .frame(idealHeight: 0.1 * screenHeight)
        .fixedSize()

      // Navigation text
      HStack {
        Button(action: {
          isPresented = false
        }) {
          Text("Back to messages".uppercased())
            .bold()
        }
        .buttonStyle(BorderlessButtonStyle())
      }
    }
  }
}
