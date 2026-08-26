//
//  FriendlyMessage.swift
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

import Foundation
import FirebaseFirestore

struct FriendlyMessage: Identifiable, Codable {
  @DocumentID var id: String?
  var text: String?
  var displayName: String?
  var imageUrl: String?
  var userId: String?

  enum CodingKeys: String, CodingKey {
    case id
    case text
    case displayName
    case name
    case imageUrl
    case userId
  }

  init(id: String? = nil, text: String? = nil, displayName: String? = nil, imageUrl: String? = nil, userId: String? = nil) {
    self.id = id
    self.text = text
    self.displayName = displayName
    self.imageUrl = imageUrl
    self.userId = userId
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    _id = try container.decodeIfPresent(DocumentID<String>.self, forKey: .id) ?? DocumentID(wrappedValue: nil)
    text = try container.decodeIfPresent(String.self, forKey: .text)
    if let name = try container.decodeIfPresent(String.self, forKey: .displayName) {
      displayName = name
    } else {
      displayName = try container.decodeIfPresent(String.self, forKey: .name)
    }
    imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
    userId = try container.decodeIfPresent(String.self, forKey: .userId)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(text, forKey: .text)
    try container.encodeIfPresent(displayName, forKey: .displayName)
    try container.encodeIfPresent(imageUrl, forKey: .imageUrl)
    try container.encodeIfPresent(userId, forKey: .userId)
  }
}
