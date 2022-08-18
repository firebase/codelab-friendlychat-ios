//
//  FriendlyMessage.swift
//  FriendlyChatSwiftUI
//
//  Created by Rachel Collins on 8/17/22.
//

import Foundation

struct FriendlyMessage: Identifiable {
  let id = UUID()
  let text: String
  let name: String
  let photoUrl: String
  let imageUrl: String
}
