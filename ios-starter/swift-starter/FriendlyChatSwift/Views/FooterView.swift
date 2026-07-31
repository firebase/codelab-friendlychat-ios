//
//  FooterView.swift
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
import PhotosUI
import FirebaseAuth
import FirebaseStorage

struct FooterView: View {
  @State private var selectedItem: PhotosPickerItem?
  @State private var messageText = ""
  @State private var isUploading = false
  @ObservedObject var viewModel: FriendlyMessageViewModel

  var body: some View {
    HStack(spacing: 12) {
      if isUploading {
        ProgressView()
          .frame(width: 28, height: 28)
      } else {
        PhotosPicker(selection: $selectedItem, matching: .images) {
          Image(systemName: "photo.on.rectangle.angled")
            .font(.system(size: 26))
            .foregroundColor(.blue)
        }
        .onChange(of: selectedItem) { newItem in
          Task {
            if let data = try? await newItem?.loadTransferable(type: Data.self) {
              await uploadAndSendImage(data: data)
            }
          }
        }
      }

      TextField("Say something...", text: $messageText)
        .padding(10)
        .background(Color.white)
        .cornerRadius(20)

      Button(action: sendMessage) {
        Image(systemName: "paperplane.fill")
          .font(.system(size: 24))
          .foregroundColor(messageText.isEmpty ? .gray : .blue)
      }
      .disabled(messageText.isEmpty)
    }
    .padding()
    .background(Color("FirebaseGray"))
  }

  private func sendMessage() {
    let textToSend = messageText
    messageText = ""
    Task {
      do {
        try await viewModel.sendMessage(text: textToSend, imageUrl: nil)
      } catch {
        print("Error sending message: \(error)")
      }
    }
  }

  private func uploadAndSendImage(data: Data) async {
    // TODO: Upload image data to Cloud Storage and send message with downloadURL
  }
}
