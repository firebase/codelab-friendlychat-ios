//
//  Copyright (c) 2015 Google Inc.
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

import Photos
import UIKit

import Firebase
import GoogleSignIn
import GoogleMobileAds

/**
 * AdMob ad unit IDs are not currently stored inside the google-services.plist file. Developers
 * using AdMob can store them as custom values in another plist, or simply use constants. Note that
 * these ad units are configured to return only test ads, and should not be used outside this sample.
 */
let kBannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"

@objc(FCViewController)
class FCViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
    UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  // Instance variables
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var sendButton: UIButton!
  var ref: DatabaseReference!
  var messages: [DataSnapshot]! = []
  var msglength: NSNumber = 10
  fileprivate var _refHandle: DatabaseHandle?

  var storageRef: StorageReference!
  var remoteConfig: RemoteConfig!

  @IBOutlet weak var banner: GADBannerView!
  @IBOutlet weak var clientTable: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clientTable.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")

    configureDatabase()
    configureStorage()
    configureRemoteConfig()
    fetchConfig()
    loadAd()
  }

  deinit {
    if let refHandle = _refHandle  {
      self.ref.child("messages").removeObserver(withHandle: refHandle)
    }
  }

  func configureDatabase() {
    ref = Database.database().reference()
    // Listen for new messages in the Firebase database
    _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
      guard let strongSelf = self else { return }
      strongSelf.messages.append(snapshot)
      strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
    })
  }

  func configureStorage() {
    storageRef = Storage.storage().reference()
  }

  func configureRemoteConfig() {
    remoteConfig = RemoteConfig.remoteConfig()
    // Create Remote Config Setting to enable developer mode.
    // Fetching configs from the server is normally limited to 5 requests per hour.
    // Setting the fetch interval to zero allows many more requests to be made per
    // hour, so developers can test different config values during development.
    let remoteConfigSettings = RemoteConfigSettings()
    remoteConfigSettings.minimumFetchInterval = 0
    remoteConfig.configSettings = remoteConfigSettings
  }

  func fetchConfig() {
    // Since the minimum fetch interval is set to zero, the next fetch will go to
    // the server unless throttling is in progress.
    // The default expiration duration is 43200 (12 hours).
    remoteConfig.fetchAndActivate() { [weak self] (status, error) in
      if status != .error {
        print("Config fetched!")
        guard let strongSelf = self else { return }
        let friendlyMsgLength = strongSelf.remoteConfig["friendly_msg_length"]
        if friendlyMsgLength.source != .static {
          strongSelf.msglength = friendlyMsgLength.numberValue!
          print("Friendly msg length config: \(strongSelf.msglength)")
        }
      } else {
        print("Config not fetched")
        if let error = error {
          print("Error \(error)")
        }
      }
    }
  }

  @IBAction func didPressFreshConfig(_ sender: AnyObject) {
    fetchConfig()
  }

  @IBAction func didSendMessage(_ sender: UIButton) {
    _ = textFieldShouldReturn(textField)
  }

  @IBAction func didPressCrash(_ sender: AnyObject) {
    print("Crash button pressed!")
    fatalError("Crash for Crashlytics")
  }

  func loadAd() {
    self.banner.adUnitID = kBannerAdUnitID
    self.banner.rootViewController = self
    self.banner.load(GADRequest())
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }

    let newLength = text.utf16.count + string.utf16.count - range.length
    return newLength <= self.msglength.intValue // Bool
  }

  // UITableViewDataSource protocol methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Dequeue cell
    let cell = self.clientTable .dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
    // Unpack message from Firebase DataSnapshot
    let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
    guard let message = messageSnapshot.value as? [String:String] else { return cell }
    let name = message[Constants.MessageFields.name] ?? ""
    if let imageURL = message[Constants.MessageFields.imageURL] {
      if imageURL.hasPrefix("gs://") {
        Storage.storage().reference(forURL: imageURL).getData(maxSize: INT64_MAX) {(data, error) in
          if let error = error {
            print("Error downloading: \(error)")
            return
          }
          DispatchQueue.main.async {
            cell.imageView?.image = UIImage.init(data: data!)
            cell.setNeedsLayout()
          }
        }
      } else if let URL = URL(string: imageURL), let data = try? Data(contentsOf: URL) {
        cell.imageView?.image = UIImage.init(data: data)
      }
      cell.textLabel?.text = "sent by: \(name)"
    } else {
      let text = message[Constants.MessageFields.text] ?? ""
      cell.textLabel?.text = name + ": " + text
      cell.imageView?.image = UIImage(named: "ic_account_circle")
      if let photoURL = message[Constants.MessageFields.photoURL], let URL = URL(string: photoURL),
          let data = try? Data(contentsOf: URL) {
        cell.imageView?.image = UIImage(data: data)
      }
    }
    return cell
  }

  // UITextViewDelegate protocol methods
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text else { return true }
    textField.text = ""
    view.endEditing(true)
    let data = [Constants.MessageFields.text: text]
    sendMessage(withData: data)
    return true
  }

  func sendMessage(withData data: [String: String]) {
    var mdata = data
    mdata[Constants.MessageFields.name] = Auth.auth().currentUser?.displayName
    if let photoURL = Auth.auth().currentUser?.photoURL {
      mdata[Constants.MessageFields.photoURL] = photoURL.absoluteString
    }

    // Push data to Firebase Database
    self.ref.child("messages").childByAutoId().setValue(mdata)
  }

  // MARK: - Image Picker

  @IBAction func didTapAddPhoto(_ sender: AnyObject) {
    let picker = UIImagePickerController()
    picker.delegate = self
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
      picker.sourceType = .camera
    } else {
      picker.sourceType = .photoLibrary
    }

    present(picker, animated: true, completion:nil)
  }

  func imagePickerController(_ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion:nil)
    guard let uid = Auth.auth().currentUser?.uid else { return }

    // if it's a photo from the library, not an image from the camera
    if #available(iOS 8.0, *), let referenceURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
      let assets = PHAsset.fetchAssets(withALAssetURLs: [referenceURL], options: nil)
      let asset = assets.firstObject
      asset?.requestContentEditingInput(with: nil, completionHandler: { [weak self] (contentEditingInput, info) in
        let imageFile = contentEditingInput?.fullSizeImageURL
        let filePath = "\(uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\((referenceURL as AnyObject).lastPathComponent!)"
        guard let strongSelf = self else { return }
        strongSelf.storageRef.child(filePath)
          .putFile(from: imageFile!, metadata: nil) { (metadata, error) in
            if let error = error {
              let nsError = error as NSError
              print("Error uploading: \(nsError.localizedDescription)")
              return
            }
            strongSelf.sendMessage(withData: [Constants.MessageFields.imageURL: strongSelf.storageRef.child((metadata?.path)!).description])
          }
      })
    } else {
      guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
      let imageData = image.jpegData(compressionQuality: 0.8)
      let imagePath = "\(uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
      let metadata = StorageMetadata()
      metadata.contentType = "image/jpeg"
      self.storageRef.child(imagePath)
        .putData(imageData!, metadata: metadata) { [weak self] (metadata, error) in
          if let error = error {
            print("Error uploading: \(error)")
            return
          }
          guard let strongSelf = self else { return }
          strongSelf.sendMessage(withData: [Constants.MessageFields.imageURL: strongSelf.storageRef.child((metadata?.path)!).description])
      }
    }
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion:nil)
  }

  @IBAction func signOut(_ sender: UIButton) {
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
      dismiss(animated: true, completion: nil)
    } catch let signOutError as NSError {
      print ("Error signing out: \(signOutError.localizedDescription)")
    }
  }

  func showAlert(withTitle title: String, message: String) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title,
            message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
  }

}
