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
import Observation
import FirebaseAuth
import FirebaseFirestore

@MainActor
@Observable
final class FriendlyMessageViewModel {
  var messages: [FriendlyMessage] = []
  @ObservationIgnored
  private var listenerTask: Task<Void, Never>?

  func startListening() {
    stopListening()
    listenerTask = Task {
      let db = Firestore.firestore()
      do {
        for try await snapshot in db.collection("messages").snapshots {
          self.messages = snapshot.documents.compactMap { document in
            try? document.data(as: FriendlyMessage.self)
          }
        }
      } catch {
        print("Error listening for messages: \(error)")
      }
    }
  }

  func stopListening() {
    listenerTask?.cancel()
    listenerTask = nil
    messages.removeAll()
  }

  func sendMessage(text: String?, imageUrl: String?) async throws {
    guard let currentUser = Auth.auth().currentUser else { return }
    let message = FriendlyMessage(
      text: text,
      displayName: currentUser.displayName ?? currentUser.email ?? "Anonymous",
      imageUrl: imageUrl,
      userId: currentUser.uid
    )
    let db = Firestore.firestore()
    _ = try db.collection("messages").addDocument(from: message)
  }
}
