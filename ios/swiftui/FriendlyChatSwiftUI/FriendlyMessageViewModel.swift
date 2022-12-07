//
//  FriendlyMessageViewModel.swift
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

import Foundation
import FirebaseDatabase

final class FriendlyMessageViewModel: ObservableObject {
  @Published var messages: [FriendlyMessage] = []

  private lazy var dbPath: DatabaseReference? = {
      return Database.database().reference().child("messages")
  }()

  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  func listen() {
    guard let dbPath = dbPath else {
      return
    }
    dbPath
      .observe(.childAdded) { [weak self] snapshot in
        guard
          let self = self,
          var json = snapshot.value as? [String: Any]
        else {
          return
        }
        json["id"] = snapshot.key
        do {
          let messageData = try JSONSerialization.data(withJSONObject: json)
          let message = try self.decoder.decode(FriendlyMessage.self, from: messageData)
          self.messages.append(message)
        } catch {
          print("Error retrieving messages: \(error)")
        }
      }
  }

  func stopListen() {
    messages = []
    dbPath?.removeAllObservers()
  }
}
