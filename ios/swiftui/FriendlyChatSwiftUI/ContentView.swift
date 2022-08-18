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
  @State private var newMessageText = ""

  // TODO: replace with database messages when Firebase Firestore is connected
  private var messages = [
    FriendlyMessage(text: "What's the Firebase logo?", name: "Dash", imageUrl: nil),
    FriendlyMessage(text: "Sparky has an image!", name: nil, imageUrl: nil),
    FriendlyMessage(text: nil, name: "Sparky", imageUrl: URL(string: "https://firebase.google.com/static/downloads/brand-guidelines/PNG/logo-logomark.png"))
  ]

  var body: some View {
    VStack {
      HeaderView()
      List(messages) {
        FriendlyMessageView(friendlyMessage: $0)
          .listRowSeparator(.hidden)
          .padding(.vertical)
      }
        .listStyle(.plain)
      FooterView(newMessageText: newMessageText)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
}
