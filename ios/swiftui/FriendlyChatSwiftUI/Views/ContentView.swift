//
//  ContentView.swift
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

struct ContentView: View {
  @AppStorage("isSignedIn") var isSignedIn = false
  @State private var newMessageText = ""
  @StateObject private var friendlyMessageVM = FriendlyMessageViewModel()
  @State private var profileViewPresented = false

  var body: some View {
    if isSignedIn {
      VStack {
        HeaderView()
        Menu {
          Button("Profile", action: {
            profileViewPresented = true
          })
          Button("Logout", action: user.logout)
        } label: {
          Image(systemName: "list.bullet.circle.fill")
            .font(.system(size: 30.0))
        }
        .frame(maxWidth: .infinity, alignment: .topTrailing)
        .padding(.horizontal)
        .sheet(isPresented: $profileViewPresented) {
          ProfileView(isPresented: $profileViewPresented, user: user)
        }
        ScrollViewReader { scrollViewReader in
          ScrollView {
            ForEach(0..<friendlyMessageVM.messages.count, id: \.self) { i in
              FriendlyMessageView(friendlyMessage: friendlyMessageVM.messages[i])
                .id(i)
                .listRowSeparator(.hidden)
                .padding(.vertical)
            }
            .onChange(of: friendlyMessageVM.messages.count) { _ in
              withAnimation(.easeInOut) {
                scrollViewReader.scrollTo(friendlyMessageVM.messages.count - 1)
              }
            }
          }
        }
        FooterView(newMessageText: newMessageText)
      }
        .onAppear {
          friendlyMessageVM.listen()
        }
        .onDisappear {
          friendlyMessageVM.stopListen()
        }
    } else {
      LoginView()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
