//
//  FriendlyMessageImageView.swift
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
import FirebaseStorage

struct FriendlyMessageImageView: View {
  let imageUrl: String
  @State private var image: UIImage?
  @State private var isLoading = true

  var body: some View {
    Group {
      if let image = image {
        Image(uiImage: image)
          .resizable()
          .scaledToFill()
          .frame(maxWidth: 200, maxHeight: 200)
          .clipShape(.rect(cornerRadius: 12))
          .clipped()
      } else if isLoading {
        ProgressView()
          .frame(width: 120, height: 120)
          .background(Color("FirebaseGray"))
          .clipShape(.rect(cornerRadius: 12))
      } else {
        Image(systemName: "photo")
          .font(.system(size: 32))
          .foregroundStyle(.gray)
          .frame(width: 120, height: 120)
          .background(Color("FirebaseGray"))
          .clipShape(.rect(cornerRadius: 12))
      }
    }
    .task {
      await loadImage()
    }
  }

  private func loadImage() async {
    isLoading = true
    defer { isLoading = false }
    if imageUrl.hasPrefix("http://") || imageUrl.hasPrefix("https://") {
      guard let url = URL(string: imageUrl),
            let (data, _) = try? await URLSession.shared.data(from: url),
            let downloadedImage = UIImage(data: data) else { return }
      self.image = downloadedImage
    } else {
      let storageRef: StorageReference
      if imageUrl.hasPrefix("gs://") {
        storageRef = Storage.storage().reference(forURL: imageUrl)
      } else {
        storageRef = Storage.storage().reference(withPath: imageUrl)
      }
      if let data = try? await storageRef.data(maxSize: 5 * 1024 * 1024),
         let downloadedImage = UIImage(data: data) {
        self.image = downloadedImage
      }
    }
  }
}

#Preview {
  FriendlyMessageImageView(imageUrl: "https://example.com/image.jpg")
}
