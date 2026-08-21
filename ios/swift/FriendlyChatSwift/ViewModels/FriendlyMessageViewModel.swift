//
//  FriendlyMessageViewModel.swift
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
import FirebaseDatabase

@MainActor
class FriendlyMessageViewModel: ObservableObject {
  @Published var messages: [FriendlyMessage] = []
  private let dbRef = Database.database().reference().child("messages")
  private var refHandle: DatabaseHandle?

  func startListening() {
    stopListening()
    refHandle = dbRef.observe(.childAdded) { [weak self] snapshot in
      guard let self = self,
            var dict = snapshot.value as? [String: Any] else { return }
      dict["id"] = snapshot.key
      if let data = try? JSONSerialization.data(withJSONObject: dict),
         let message = try? JSONDecoder().decode(FriendlyMessage.self, from: data) {
        Task { @MainActor in
          self.messages.append(message)
        }
      }
    }
  }

  func stopListening() {
    if let handle = refHandle {
      dbRef.removeObserver(withHandle: handle)
      refHandle = nil
    }
    messages.removeAll()
  }

  func sendMessage(text: String?, imageUrl: String?) async throws {
    guard let currentUser = Auth.auth().currentUser else { return }
    let newChildRef = dbRef.childByAutoId()
    let message = FriendlyMessage(
      id: newChildRef.key ?? UUID().uuidString,
      text: text,
      displayName: currentUser.displayName ?? currentUser.email ?? "Anonymous",
      imageUrl: imageUrl,
      userId: currentUser.uid
    )
    guard let dict = try? JSONSerialization.jsonObject(with: JSONEncoder().encode(message)) else { return }
    try await newChildRef.setValue(dict)
  }
}
