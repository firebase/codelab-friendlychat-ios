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
  @StateObject private var friendlyMessageVM = MessageViewModel()

  var body: some View {
    if isSignedIn {
      VStack {
        HeaderView()
        Button(action:user.logout) {
          Text("Logout")
            .frame(maxWidth: .infinity, alignment: .topTrailing)
        }
          .padding(.horizontal)
        List(friendlyMessageVM.messages) { message in
          FriendlyMessageView(friendlyMessage: message)
            .listRowSeparator(.hidden)
            .padding(.vertical)
        }
          .listStyle(.plain)
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
