//
//  FriendlyMessageTextView.swift
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

struct FriendlyMessageTextView: View {
  var text: String
  var isUserText: Bool

  var body: some View {
    Text(text)
      .padding(.horizontal, 16)
      .padding(.vertical, 10)
      .background(isUserText ? Color("FirebaseBlue") : Color("FirebaseGray"))
      .foregroundColor(isUserText ? .white : .primary)
      .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
  }
}

struct FriendlyMessageTextView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      FriendlyMessageTextView(text: "Hello from current user!", isUserText: true)
      FriendlyMessageTextView(text: "Hello from someone else!", isUserText: false)
    }
  }
}
