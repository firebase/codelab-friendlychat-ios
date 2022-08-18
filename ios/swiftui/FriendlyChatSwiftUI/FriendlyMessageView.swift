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
    HStack{
      // profile image
      Image("defaultProfileImage")
          .aspectRatio(contentMode: .fit)
      VStack(alignment: .leading) {
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
          Text(friendlyMessage.text)
            .padding(.horizontal, 16)
            .padding(.vertical)
            .layoutPriority(1)
        }
        Text(friendlyMessage.name)
          .foregroundColor(Color.gray)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      //on zstack: .frame(width: 300, height: 40)
    }

  }
}

struct FriendlyMessageView_Previews: PreviewProvider {
    static let friendlyMessagePreview = FriendlyMessage(
      text: "Text preview",
      name: "name preview",
      photoUrl: "photo url preview",
      imageUrl: "image url preview"
    )

    static var previews: some View {
        FriendlyMessageView(friendlyMessage: friendlyMessagePreview)
    }
}
