//
//  ContentView.swift
//  FriendlyChatSwiftUI
//
//  Created by Rachel Collins on 8/17/22.
//

import SwiftUI

struct ContentView: View {
  @State private var newMessageText = ""
  private var messages = [
    FriendlyMessage(text: "Message 1", name: "Name 1", photoUrl: "photourl 1", imageUrl: "imageurl 1"),
    FriendlyMessage(text: "Message 2", name: "Name 2", photoUrl: "photourl 2", imageUrl: "imageurl 2"),
    FriendlyMessage(text: "Message 3", name: "Name 3", photoUrl: "photourl 3", imageUrl: "imageurl 3")
  ]


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
          .padding()
      }
        .listStyle(.plain)
      Group {
        HStack {
          Text("Add image")
          TextField(
            "Say something...",
            text: $newMessageText
          )
            .padding()
            .background(Color.white)
          Text("Send")
        }
          .padding()
      }
        .background(Color.gray)
        .ignoresSafeArea()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
}
