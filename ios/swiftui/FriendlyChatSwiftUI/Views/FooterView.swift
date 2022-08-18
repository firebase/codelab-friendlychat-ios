//
//  FooterView.swift
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

struct FooterView: View {
  @State var newMessageText: String
  @State private var isPresentingAlert: Bool = false
  @State private var image = UIImage()
  @State private var showSheet = false

  func presentDialog() {
    if (newMessageText != "") {
      isPresentingAlert = true
      newMessageText = ""
    }
  }

  func showImagePicker() {
    showSheet = true
  }
  
  var body: some View {
    Group {
      HStack {
        Button(action: showImagePicker) {
          Image(systemName: "square.and.arrow.up")
            .font(.system(size: 30.0))
        }
          .onTapGesture {
            showSheet = true
          }
        TextField(
          "Say something...",
          text: $newMessageText
        )
          .padding()
          .background(Color.white)
        if (newMessageText != "") {
          Button(action: presentDialog) {
            Image(systemName: "paperplane")
              .font(.system(size: 30.0))
          }
        } else {
          Image(systemName: "paperplane")
            .font(.system(size: 30.0))
        }
      }
        .padding()
    }
      .background(Color("FirebaseGray"))
      .alert("Sending Friendly Chat! (this doesn't do anything)",
        isPresented: $isPresentingAlert) {
      }
      .sheet(isPresented: $showSheet) {
        ImagePicker(selectedImage: self.$image)
      }
  }
}


