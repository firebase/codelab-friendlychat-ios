//
//  ImageUploader.swift
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
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class ImageUploader: ObservableObject {
  let storage = Storage.storage()
  let user = Auth.auth().currentUser
  let db = Database.database()

  func uploadImage(image: UIImage) {
    let storageRef = storage.reference().child(user!.uid).child("images").child(image.description)
    let imageData = image.jpegData(compressionQuality: 0.5)
    let dbRef = db.reference()

    // Upload the file and send as message to db
    if let imageData = imageData {
      storageRef.putData(imageData, metadata: nil).observe(.success) { snapshot in
        // Upload completed successfully
        dbRef.child("messages").childByAutoId().setValue(["imageUrl": storageRef.fullPath])
      }
    }
  }
}



