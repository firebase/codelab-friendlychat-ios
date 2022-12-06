//
//  FriendlyMessageView.swift
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

import FirebaseAuth
import SwiftUI

struct FriendlyMessageView: View {
  var friendlyMessage: FriendlyMessage
  let currentUserName = Auth.auth().currentUser?.displayName

  var body: some View {
    HStack {
      if (friendlyMessage.name != nil) {
        InitialsView(name: friendlyMessage.name!)
      } else {
        Image(systemName: "person.crop.circle")
          .font(.system(size: 45.0))
      }
      VStack(alignment: .leading) {
        if (friendlyMessage.imageUrl != nil) {
          FriendlyMessageImageView(url: friendlyMessage.imageUrl!)
        }
        else {
          ZStack {
           FriendlyMessageTextView(text: friendlyMessage.text!, isUserText: friendlyMessage.name == currentUserName)
          }
        }
        if (friendlyMessage.name != nil) {
          Text(friendlyMessage.name!)
            .foregroundColor(Color.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
          Text("anonymous")
            .foregroundColor(Color.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
    }

  }
}

struct FriendlyMessageView_Previews: PreviewProvider {
    static let friendlyMessagePreview = FriendlyMessage(
      id: "1234",
      text: "Text preview",
      name: "name preview",
      imageUrl: URL(string: "https://firebase.google.com/static/downloads/brand-guidelines/PNG/logo-logomark.png")
    )

    static var previews: some View {
        FriendlyMessageView(friendlyMessage: friendlyMessagePreview)
    }
}
