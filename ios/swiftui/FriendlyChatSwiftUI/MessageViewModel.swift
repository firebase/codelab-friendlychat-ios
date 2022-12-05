import Foundation
import FirebaseDatabase

final class MessageViewModel: ObservableObject {
  @Published var messages: [FriendlyMessage] = []

  private lazy var dbPath: DatabaseReference? = {
      return Database.database().reference().child("messages")
  }()

  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  func listen() {
    guard let dbPath = dbPath else {
      return
    }
    dbPath
      .observe(.childAdded) { [weak self] snapshot in
        guard
          let self = self,
          var json = snapshot.value as? [String: Any]
        else {
          return
        }
        json["id"] = snapshot.key
        do {
          let messageData = try JSONSerialization.data(withJSONObject: json)
          let message = try self.decoder.decode(FriendlyMessage.self, from: messageData)
          self.messages.append(message)
        } catch {
          print("an error occurred", error)
        }
      }
  }

  func stopListen() {
    dbPath?.removeAllObservers()
  }
}
