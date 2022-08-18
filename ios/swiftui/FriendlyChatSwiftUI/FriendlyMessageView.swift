//
//  FriendlyMessageView.swift
//  FriendlyChatSwiftUI
//
//  Created by Rachel Collins on 8/17/22.
//

import SwiftUI

struct FriendlyMessageView: View {
  var friendlyMessage: FriendlyMessage
  let currentUserName = "Name 1"

  var body: some View {
    HStack {
      if (friendlyMessage.name != nil) {
        ZStack(alignment: .center) {
          Circle()
            .frame(width: 45, height: 45)
            .foregroundColor(Color.yellow)
          Text(friendlyMessage.name!.prefix(1))
        }
      } else {
        Image(systemName: "person.crop.circle")
          .font(.system(size: 45.0))
      }
      VStack(alignment: .leading) {
        if (friendlyMessage.imageUrl != nil) {
          AsyncImage(url: friendlyMessage.imageUrl!) { image in
            image
              .resizable()
              .scaledToFill()
          } placeholder: {
            Image(systemName: "photo")
          }
          .frame(maxWidth: 150, alignment: .leading)
        }
        else {
          ZStack {
            if (friendlyMessage.name == currentUserName) {
              Image("blueRectangle")
                  .resizable()
                  .clipShape(RoundedRectangle(cornerRadius: 25))
            } else {
              Image("grayRectangle")
                  .resizable()
                  .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            Text(friendlyMessage.text!)
              .padding()
              .layoutPriority(1)
          }
        }
        if (friendlyMessage.name != nil) {
          Text(friendlyMessage.name!)
            .foregroundColor(Color.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
          Text("anonymous")
            .foregroundColor(Color.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
    }

  }
}

struct FriendlyMessageView_Previews: PreviewProvider {
    static let friendlyMessagePreview = FriendlyMessage(
      text: "Text preview",
      name: "name preview",
      imageUrl: URL(string: "https://firebase.google.com/static/downloads/brand-guidelines/PNG/logo-logomark.png")
    )

    static var previews: some View {
        FriendlyMessageView(friendlyMessage: friendlyMessagePreview)
    }
}
