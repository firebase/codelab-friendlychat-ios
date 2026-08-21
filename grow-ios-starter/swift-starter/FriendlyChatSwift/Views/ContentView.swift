//
//  ContentView.swift
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

struct ContentView: View {
  @StateObject private var userViewModel = UserViewModel()
  @StateObject private var messageViewModel = FriendlyMessageViewModel()
  @State private var profileViewPresented = false

  var body: some View {
    if userViewModel.user != nil {
      VStack(spacing: 0) {
        HeaderView()
        
        HStack {
          Spacer()
          Menu {
            Button("Profile", action: {
              profileViewPresented = true
            })
            Button("Logout", action: userViewModel.signOut)
          } label: {
            Image(systemName: "list.bullet.circle.fill")
              .font(.system(size: 28))
              .foregroundColor(.blue)
          }
        }
        .padding(.horizontal)
        .padding(.top, 4)
        .sheet(isPresented: $profileViewPresented) {
          ProfileView(isPresented: $profileViewPresented, userViewModel: userViewModel)
        }

        ScrollViewReader { scrollViewReader in
          ScrollView {
            LazyVStack(spacing: 12) {
              ForEach(Array(messageViewModel.messages.enumerated()), id: \.element.id) { index, message in
                FriendlyMessageView(friendlyMessage: message)
                  .id(index)
              }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .onChange(of: messageViewModel.messages.count) { count in
              guard count > 0 else { return }
              withAnimation(.easeInOut) {
                scrollViewReader.scrollTo(count - 1, anchor: .bottom)
              }
            }
          }
        }

        FooterView(viewModel: messageViewModel)
      }
      .onAppear {
        messageViewModel.startListening()
      }
      .onDisappear {
        messageViewModel.stopListening()
      }
    } else {
      LoginView(userViewModel: userViewModel)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
