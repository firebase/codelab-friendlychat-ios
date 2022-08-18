//
//  ContentView.swift
//  FriendlyChatSwiftUI
//
//  Created by Rachel Collins on 8/17/22.
//

import SwiftUI

struct ContentView: View {
  @State private var newMessageText = ""
  //temporary until db is connected via Firebase
  @State private var isPresentingAlert: Bool = false
  @State private var image = UIImage()
  @State private var showSheet = false

  private var messages = [
    FriendlyMessage(text: "Message 1", name: "Name 1", imageUrl: nil),
    FriendlyMessage(text: "Message 2", name: nil, imageUrl: nil),
    FriendlyMessage(text: nil, name: "Name 3", imageUrl: URL(string: "https://firebase.google.com/static/downloads/brand-guidelines/PNG/logo-logomark.png"))
  ]

  func presentDialog() {
    if (newMessageText != "") {
      isPresentingAlert = true
      newMessageText = ""
    }
  }

  func showImagePicker() {
    self.showSheet = true
  }

  var body: some View {
    VStack {
      Text("Friendly Chat")
        .frame(width: 375, height: 30, alignment: .topLeading)
        .font(.system(size: 28))
        .padding()
        .background(Color.orange)
        .foregroundColor(Color.white)
      List(messages) {
        FriendlyMessageView(friendlyMessage: $0)
          .listRowSeparator(.hidden)
          .padding(.vertical)
      }
        .listStyle(.plain)
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
        .background(Color.gray)
        .ignoresSafeArea()
    }
      .alert("Sending Friendly Chat! (this doesn't do anything)",
        isPresented: $isPresentingAlert) {
      }
      .sheet(isPresented: $showSheet) {
        ImagePicker(selectedImage: self.$image)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
}
