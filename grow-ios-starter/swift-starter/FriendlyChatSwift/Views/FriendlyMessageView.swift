//
//  FriendlyMessageView.swift
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

struct FriendlyMessageView: View {
  var friendlyMessage: FriendlyMessage

  private var isCurrentUserMessage: Bool {
    if let currentUid = Auth.auth().currentUser?.uid,
       let senderUid = friendlyMessage.userId,
       !senderUid.isEmpty {
      return currentUid == senderUid
    }
    if let currentName = Auth.auth().currentUser?.displayName,
       let senderName = friendlyMessage.displayName,
       !currentName.isEmpty {
      return currentName == senderName
    }
    return false
  }

  var body: some View {
    HStack(alignment: .top, spacing: 10) {
      if !isCurrentUserMessage {
        if let name = friendlyMessage.displayName, !name.isEmpty {
          InitialsView(name: name)
        } else {
          Image(systemName: "person.crop.circle.fill")
            .font(.system(size: 42))
            .foregroundStyle(.gray)
        }
      } else {
        Spacer()
      }

      VStack(alignment: isCurrentUserMessage ? .trailing : .leading, spacing: 4) {
        if let imageUrl = friendlyMessage.imageUrl, !imageUrl.isEmpty {
          FriendlyMessageImageView(imageUrl: imageUrl)
        } else if let text = friendlyMessage.text {
          FriendlyMessageTextView(text: text, isUserText: isCurrentUserMessage)
        }

        Text(friendlyMessage.displayName ?? "Anonymous")
          .font(.caption)
          .foregroundStyle(.gray)
      }

      if isCurrentUserMessage {
        if let name = friendlyMessage.displayName, !name.isEmpty {
          InitialsView(name: name)
        } else {
          Image(systemName: "person.crop.circle.fill")
            .font(.system(size: 42))
            .foregroundStyle(.gray)
        }
      } else {
        Spacer()
      }
    }
  }
}

#Preview {
  FriendlyMessageView(friendlyMessage: FriendlyMessage(id: "1", text: "Hello world", displayName: "Google", imageUrl: nil))
}
