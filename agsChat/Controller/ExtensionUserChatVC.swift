//
//  ExtensionUserChatVC.swift
//  agsChat
//
//  Created by MAcBook on 11/07/22.
//

import Foundation
import UIKit
import AVKit
import MobileCoreServices
import AVFoundation
import AVFAudio

// MARK: - Textfiled Delegate
extension UserChatVC : UITextFieldDelegate {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.isKeyboardActive = true
        if let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            constMainChatViewBottom.constant = keyboardSize.height - 35
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.isKeyboardActive = false
        constMainChatViewBottom.constant = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}

// MARK: - TableView Delegate
extension UserChatVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrDtForSection?.count ?? 0
    }   //  */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView()//UIView(frame: CGRect.zero)
        viewHeader.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45)
        viewHeader.backgroundColor = .clear
        let lblHeaderTitle : UILabel = UILabel()    //(frame: CGRect.zero)
        lblHeaderTitle.frame = CGRect(x: 5, y: 5, width: 115, height: 35)
        lblHeaderTitle.center = viewHeader.center
        lblHeaderTitle.clipsToBounds = true
        lblHeaderTitle.layer.cornerRadius = 7
        lblHeaderTitle.text = self.arrDtForSection![section]
        lblHeaderTitle.font = .boldSystemFont(ofSize: 16)
        lblHeaderTitle.textAlignment = .center
        lblHeaderTitle.textColor = UIColor(red: 84/255, green: 101/255, blue: 111/255, alpha: 1)
        lblHeaderTitle.backgroundColor = .white
        viewHeader.addSubview(lblHeaderTitle)

        return viewHeader
    }   //  */
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return arrUserChat1?[keys[section]]?.count ?? 0
        //return arrGetPreviousChat!.count
        return self.arrSectionMsg![section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msgType : String = (self.arrSectionMsg![indexPath.section][indexPath.row].type)!
        if (self.arrSectionMsg![indexPath.section][indexPath.row].sentBy)! == myUserId
        {
            //let msgType : String = (arrGetPreviousChat![indexPath.row].type)!
            //let msgType : String = (self.arrSectionMsg![indexPath.section][indexPath.row].type)!
            if msgType == "document"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OwnFileBubbleCell", for: indexPath) as! OwnFileBubbleCell
                cell.imgDocument.image = UIImage(named: "document")
                cell.lblFileName.text = "Document File"
                cell.lblTime.text = Utility.convertTimestamptoTimeString(timestamp: "\((self.arrSectionMsg![indexPath.section][indexPath.row].sentAt?.seconds)!)")
                return cell
            }
            else if msgType == "image"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OwnImgChatBubbleCell", for: indexPath) as! OwnImgChatBubbleCell
                //cell.configure(msgType, (arrGetPreviousChat![indexPath.row].image)!)
                cell.configure(msgType, (self.arrSectionMsg![indexPath.section][indexPath.row].image)!, "")
                cell.lblTime.text = Utility.convertTimestamptoTimeString(timestamp: "\((self.arrSectionMsg![indexPath.section][indexPath.row].sentAt?.seconds)!)")
                return cell
            }
            else if msgType == "video"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OwnImgChatBubbleCell", for: indexPath) as! OwnImgChatBubbleCell
                cell.configure(msgType, "", (self.arrSectionMsg![indexPath.section][indexPath.row].base64Thumbnail)!)
                cell.lblTime.text = Utility.convertTimestamptoTimeString(timestamp: "\((self.arrSectionMsg![indexPath.section][indexPath.row].sentAt?.seconds)!)")
                return cell
            }
            else if msgType == "audio"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OwnAudioBubbleCell", for: indexPath) as! OwnAudioBubbleCell
                cell.imgAudio.image = UIImage(named: "audio")
                cell.lblFileName.text = "Audio File"
                cell.lblTime.text = Utility.convertTimestamptoTimeString(timestamp: "\((self.arrSectionMsg![indexPath.section][indexPath.row].sentAt?.seconds)!)")
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OwnChatBubbleCell", for: indexPath) as! OwnChatBubbleCell
                cell.lblMsg.text = (self.arrSectionMsg![indexPath.section][indexPath.row].message)!
                cell.lblTime.text = Utility.convertTimestamptoTimeString(timestamp: "\((self.arrSectionMsg![indexPath.section][indexPath.row].sentAt?.seconds)!)")
                return cell
            }
        }
        else
        {
            //let msgType : String = (arrGetPreviousChat![indexPath.row].type)!
            //let msgType : String = (self.arrSectionMsg![indexPath.section][indexPath.row].type)!
            if msgType == "document"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherFileBubbleCell", for: indexPath) as! OtherFileBubbleCell
                cell.imgDocument.image = UIImage(named: "document")
                cell.lblFileName.text = "Document File"
                cell.lblTime.text = Utility.convertTimestamptoTimeString(timestamp: "\((self.arrSectionMsg![indexPath.section][indexPath.row].sentAt?.seconds)!)")
                return cell
            }
            else if msgType == "image"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherImgChatBubbleCell", for: indexPath) as! OtherImgChatBubbleCell
                cell.configure(msgType, (self.arrSectionMsg![indexPath.section][indexPath.row].image)!, "")
                cell.lblTime.text = Utility.convertTimestamptoTimeString(timestamp: "\((self.arrSectionMsg![indexPath.section][indexPath.row].sentAt?.seconds)!)")
                return cell
            }
            else if msgType == "video"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherImgChatBubbleCell", for: indexPath) as! OtherImgChatBubbleCell
                cell.configure(msgType, "", (self.arrSectionMsg![indexPath.section][indexPath.row].base64Thumbnail)!)
                cell.lblTime.text = Utility.convertTimestamptoTimeString(timestamp: "\((self.arrSectionMsg![indexPath.section][indexPath.row].sentAt?.seconds)!)")
                return cell
            }
            else if msgType == "audio"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherAudioBubbleCell", for: indexPath) as! OtherAudioBubbleCell
                cell.imgAudio.image = UIImage(named: "audio")
                cell.lblFileName.text = "Audio File"
                cell.lblTime.text = Utility.convertTimestamptoTimeString(timestamp: "\((self.arrSectionMsg![indexPath.section][indexPath.row].sentAt?.seconds)!)")
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherChatBubbleCell", for: indexPath) as! OtherChatBubbleCell
                cell.lblMsg.text = (self.arrSectionMsg![indexPath.section][indexPath.row].message)!
                cell.lblTime.text = Utility.convertTimestamptoTimeString(timestamp: "\((self.arrSectionMsg![indexPath.section][indexPath.row].sentAt?.seconds)!)")
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msgType : String = (self.arrSectionMsg![indexPath.section][indexPath.row].type)!
        if msgType == "document" {
            let fileName = "123.doc"    //  get file name from chat array
            do {
            let documentUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let fileUrl = documentUrl.appendingPathComponent(fileName)
                if FileManager.default.fileExists(atPath: fileUrl.path) {
                    print("Open already downloaded file...")
                } else {
                    NetworkManager.sharedInstance.download(url: URL(string: (self.arrSectionMsg![indexPath.section][indexPath.row].document)!)!, fileLocation: fileUrl, obj: self) { result in
                        print(result)
                    }
                }
                print(fileUrl.path)
            } catch let error {
                print(error.localizedDescription)
            }
        } else if msgType == "video" {
            let url : String = (self.arrSectionMsg![indexPath.section][indexPath.row].video)!
            let player = AVPlayer(url: URL(string: url)!)
            let vcPlayer = AVPlayerViewController()
            vcPlayer.player = player
            self.present(vcPlayer, animated: true, completion: nil) //  */
        } else if msgType == "image" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc =  sb.instantiateViewController(withIdentifier: "ImageViewerVC") as! ImageViewerVC
            vc.strImageName = (self.arrSectionMsg![indexPath.section][indexPath.row].image)!
            //self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true)
        } else if msgType == "audio" {
            //http://freetone.org/ring/stan/iPhone_5-Alarm.mp3
            //https://s3.amazonaws.com/kargopolov/kukushka.mp3
            let url = URL(string: "https://s3.amazonaws.com/kargopolov/kukushka.mp3")
            
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            //var fileName : String = (url!.deletingPathExtension()).lastPathComponent
            let fileName : String = url!.lastPathComponent
            //var fileExt : String = url!.pathExtension
            print(fileName)
            
            //let audioName = "\(Utility.fileName()).mp3"
            let fileUrl = documentsDirectory.appendingPathComponent(fileName)
            var isFileExist : Bool = false
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                isFileExist = true
            } else {
                URLSession.shared.downloadTask(with: url!, completionHandler: {
                    location, response, error in
                    do {
                        //try data.write(to: fileUrl)
                        //location.write(to: fileUrl)
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location!, to: fileUrl)
                        print("File moved to documents folder")
                        isFileExist = true
                        self.playAudio(isFileExist: isFileExist, filePath: fileUrl)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
            }
            playAudio(isFileExist: isFileExist, filePath: fileUrl)
        }
    }
    
    func playAudio(isFileExist : Bool, filePath : URL) {
        if isFileExist {
            DispatchQueue.main.async {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc =  sb.instantiateViewController(withIdentifier: "AudioPlayerVC") as! AudioPlayerVC
                vc.filePath = filePath
                self.present(vc, animated: true)
            }
        }
    }
}

// MARK: - Camera, Gallary
extension UserChatVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = ["public.image", "public.movie"]
            isCameraClick = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: "Camera", message: "Camera not working.", preferredStyle: .alert)
            alertWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { alert in
            }))
            self.present(alertWarning, animated: true)
        }
    }
    
    func fromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = ["public.image", "public.movie"]
            isCameraClick = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //also use for camera capture image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if isCameraClick && (info[.editedImage] is UIImage) {
            self.dismiss(animated: true) {
                guard let image = info[.editedImage] as? UIImage else {
                    print("No image found")
                    return
                }
                
                guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                let imageName = "\(Utility.fileName()).png"
                let fileUrl = documentsDirectory.appendingPathComponent(imageName)
                guard let data = image.jpegData(compressionQuality: 1) else { return }
                do {
                    try data.write(to: fileUrl)
                } catch let error {
                    print("error saving file with error --", error)
                }
                
                if FileManager.default.fileExists(atPath: fileUrl.path) {
                    
                    let appImage = UIImage(contentsOfFile: fileUrl.path)
                    let imgData = appImage?.pngData()
                    print(imgData!)
                    
                    let param : [String : Any] = ["image": imgData!, "isRead" : false, "type" : "image", "viewBy" : (self.recentChatUser?.members)!, "readBy" : myUserId, "sentAt" : "", "sentBy" : myUserId, "timeMilliSeconds" : ""]
                    let param1 : [String : Any] = ["messageObj" : param, "groupId" : (self.recentChatUser?.groupId)!, "secretKey" : secretKey]
                    
                    if self.sendMessage(param: param1) {
                        let timestamp : Int = Int(NSDate().timeIntervalSince1970)
                        let sentAt : [String : Any] = ["seconds" : timestamp]
                        let msg : [String : Any] = ["sentBy" : myUserId,
                                                    "type" : "image",
                                                    "sentAt" : sentAt,
                                                    "image" : fileUrl.path]
                        
                        if self.loadChatMsgToArray(msg: msg, timestamp: timestamp) {
                            self.tblUserChat.reloadData()
                            self.tblUserChat.scrollToRow(at: IndexPath(row: (self.arrSectionMsg![self.arrSectionMsg!.count - 1].count - 1), section: (self.arrSectionMsg!.count - 1)), at: .bottom, animated: true)
                        }
                    }
                }
            }
        } else if info[UIImagePickerController.InfoKey.originalImage] is UIImage {
            self.dismiss(animated: true) {
                //let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL
                let imageUrl = info[.imageURL] as? URL
                print("Image Url - \(imageUrl!)")
                
                //let appImage = UIImage(named: "\(imageUrl!)")
                let appImage = UIImage(contentsOfFile: imageUrl!.path)
                let imgData = appImage?.pngData()
                
                let param : [String : Any] = ["image": imgData!, "isRead" : false, "type" : "image", "viewBy" : (self.recentChatUser?.members)!, "readBy" : myUserId, "sentAt" : "", "sentBy" : myUserId, "timeMilliSeconds" : ""]
                let param1 : [String : Any] = ["messageObj" : param, "groupId" : (self.recentChatUser?.groupId)!, "secretKey" : secretKey]
                
                if self.sendMessage(param: param1) {
                    let timestamp : Int = Int(NSDate().timeIntervalSince1970)
                    let sentAt : [String : Any] = ["seconds" : timestamp]
                    let msg : [String : Any] = ["sentBy" : myUserId,
                                                "type" : "image",
                                                "sentAt" : sentAt,
                                                "image" : imageUrl!.path]
                    
                    if self.loadChatMsgToArray(msg: msg, timestamp: timestamp) {
                        self.tblUserChat.reloadData()
                        self.tblUserChat.scrollToRow(at: IndexPath(row: (self.arrSectionMsg![self.arrSectionMsg!.count - 1].count - 1), section: (self.arrSectionMsg!.count - 1)), at: .bottom, animated: true)
                    }
                }
                //SocketChatManager.sharedInstance.sendMsg(message: ["image": imgData!, "sentBy" : myUserId, "rid": self.groupId, "type" : "image", "name" : (imageUrl?.lastPathComponent)!])
                
            }
        } else {
            let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            print("Video_ URL - \((videoUrl?.path)!)")
            
            self.dismiss(animated: true) {
                
                do {
                    //let videoData = try Data(contentsOf: videoUrl!)
                    let videoD = NSData.dataWithContentsOfMappedFile(videoUrl!.path)
                    //print(videoData)
                    print(videoD!)
                    
                    // Get thumbnail image from video.
                    let asset = AVURLAsset(url: videoUrl!, options: nil)
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    var uiImage = UIImage()
                    do {
                        //let cgImage = imgGenerator.copyCGImage(at: CMTime(0,1), actualTime: nil)
                        let cgImage = try imgGenerator.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: 1), actualTime: nil)
                        uiImage = UIImage(cgImage: cgImage)
                        //let imageView = UIImageView(image: uiImage)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                    let imgData = uiImage.pngData()
                    print(imgData!)
                    SocketChatManager.sharedInstance.sendMsg(message: ["video": videoD!, "sentBy" : myUserId, "rid": self.groupId, "type" : "video", "name" : (videoUrl?.lastPathComponent)!, "base64Thumbnail" : imgData!])
                    
                    // load msg to chat table
                    
                    let param : [String : Any] = ["video": videoD!, "isRead" : false, "type" : "video", "viewBy" : (self.recentChatUser?.members)!, "readBy" : myUserId, "sentAt" : "", "sentBy" : myUserId, "timeMilliSeconds" : ""]
                    let param1 : [String : Any] = ["messageObj" : param, "groupId" : (self.recentChatUser?.groupId)!, "secretKey" : secretKey]
                    
                    if self.sendMessage(param: param1) {
                        let timestamp : Int = Int(NSDate().timeIntervalSince1970)
                        let sentAt : [String : Any] = ["seconds" : timestamp]
                        let msg : [String : Any] = ["sentBy" : myUserId,
                                                    "type" : "video",
                                                    "sentAt" : sentAt,
                                                    "video" : videoUrl!.path,
                                                    "base64Thumbnail" : imgData!]
                        
                        if self.loadChatMsgToArray(msg: msg, timestamp: timestamp) {
                            self.tblUserChat.reloadData()
                            self.tblUserChat.scrollToRow(at: IndexPath(row: (self.arrSectionMsg![self.arrSectionMsg!.count - 1].count - 1), section: (self.arrSectionMsg!.count - 1)), at: .bottom, animated: true)
                        }
                    }
                    
                } catch {
                    print("error")
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
        }
    }
    
}

// MARK: - Select document
extension UserChatVC : UIDocumentPickerDelegate, UIDocumentMenuDelegate {
    
    @available(iOS 14.0, *)
    func selectFiles() {
        let documentsPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "public.data"], in: .import)
        documentsPicker.delegate = self
        documentsPicker.allowsMultipleSelection = false
        documentsPicker.modalPresentationStyle = .fullScreen
        self.present(documentsPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        //Check - if selected document is image then check extension and display image.
        let url = urls.first! as URL
        if arrImageExtension.contains((url.pathExtension).lowercased()) {
            //Need to make a new image with the jpeg data to be able to close the security resources!
            guard let image = UIImage(contentsOfFile: url.path), let imageCopy = UIImage(data: image.jpegData(compressionQuality: 1.0)!) else { return }
            
            let imgData = image.pngData()
            print(imgData!)
            
            //SocketChatManager.sharedInstance.sendMsg(message: ["image": imgData!, "sentBy" : myUserId, "rid": self.groupId, "type" : "image", "name" : url.lastPathComponent])
            
            // load msg to chat table
            
            let param : [String : Any] = ["image": imgData!, "isRead" : false, "type" : "image", "viewBy" : (self.recentChatUser?.members)!, "readBy" : myUserId, "sentAt" : "", "sentBy" : myUserId, "timeMilliSeconds" : ""]
            let param1 : [String : Any] = ["messageObj" : param, "groupId" : (self.recentChatUser?.groupId)!, "secretKey" : secretKey]
            
            if self.sendMessage(param: param1) {
                let timestamp : Int = Int(NSDate().timeIntervalSince1970)
                let sentAt : [String : Any] = ["seconds" : timestamp]
                let msg : [String : Any] = ["sentBy" : myUserId,
                                            "type" : "image",
                                            "sentAt" : sentAt,
                                            "image" : urls.first!]
                
                if self.loadChatMsgToArray(msg: msg, timestamp: timestamp) {
                    self.tblUserChat.reloadData()
                    self.tblUserChat.scrollToRow(at: IndexPath(row: (self.arrSectionMsg![self.arrSectionMsg!.count - 1].count - 1), section: (self.arrSectionMsg!.count - 1)), at: .bottom, animated: true)
                }
            }
            
        } else if arrDocExtension.contains((url.pathExtension).lowercased()) {
            do {
                //var myData = NSData(contentsOfURL: url)
                let myData = try Data(contentsOf: url)
                print(myData)
                
                //SocketChatManager.sharedInstance.sendMsg(message: ["document": myData, "sentBy" : myUserId, "rid": self.groupId, "type" : "document", "name" : url.lastPathComponent])
                
                // load msg to chat table
                
                let param : [String : Any] = ["document": myData, "isRead" : false, "type" : "document", "viewBy" : (self.recentChatUser?.members)!, "readBy" : myUserId, "sentAt" : "", "sentBy" : myUserId, "timeMilliSeconds" : ""]
                let param1 : [String : Any] = ["messageObj" : param, "groupId" : (self.recentChatUser?.groupId)!, "secretKey" : secretKey]
                
                if self.sendMessage(param: param1) {
                    let timestamp : Int = Int(NSDate().timeIntervalSince1970)
                    let sentAt : [String : Any] = ["seconds" : timestamp]
                    let msg : [String : Any] = ["sentBy" : myUserId,
                                                "type" : "document",
                                                "sentAt" : sentAt,
                                                "document" : urls.first!]
                    
                    if self.loadChatMsgToArray(msg: msg, timestamp: timestamp) {
                        self.tblUserChat.reloadData()
                        self.tblUserChat.scrollToRow(at: IndexPath(row: (self.arrSectionMsg![self.arrSectionMsg!.count - 1].count - 1), section: (self.arrSectionMsg!.count - 1)), at: .bottom, animated: true)
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        } else if arrAudioExtension.contains((url.pathExtension).lowercased()) {
            do {
                //var myData = NSData(contentsOfURL: url)
                let myData = try Data(contentsOf: url)
                print(myData)
                //SocketChatManager.sharedInstance.sendMsg(message: ["audio": myData, "sentBy" : myUserId, "rid": self.groupId, "type" : "audio", "name" : url.lastPathComponent])
                
                // load msg to chat table
                
                let param : [String : Any] = ["audio": myData, "isRead" : false, "type" : "audio", "viewBy" : (self.recentChatUser?.members)!, "readBy" : myUserId, "sentAt" : "", "sentBy" : myUserId, "timeMilliSeconds" : ""]
                let param1 : [String : Any] = ["messageObj" : param, "groupId" : (self.recentChatUser?.groupId)!, "secretKey" : secretKey]
                
                if self.sendMessage(param: param1) {
                    let timestamp : Int = Int(NSDate().timeIntervalSince1970)
                    let sentAt : [String : Any] = ["seconds" : timestamp]
                    let msg : [String : Any] = ["sentBy" : myUserId,
                                                "type" : "audio",
                                                "sentAt" : sentAt,
                                                "audio" : urls.first!]
                    
                    if self.loadChatMsgToArray(msg: msg, timestamp: timestamp) {
                        self.tblUserChat.reloadData()
                        self.tblUserChat.scrollToRow(at: IndexPath(row: (self.arrSectionMsg![self.arrSectionMsg!.count - 1].count - 1), section: (self.arrSectionMsg!.count - 1)), at: .bottom, animated: true)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else if arrVideoExtension.contains((url.pathExtension).lowercased()) {
            do {
                //var myData = NSData(contentsOfURL: url)
                let myData = try Data(contentsOf: url)
                print(myData)
                
                // Get thumbnail image from video.
                let asset = AVURLAsset(url: url, options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                var uiImage = UIImage()
                do {
                    //let cgImage = imgGenerator.copyCGImage(at: CMTime(0,1), actualTime: nil)
                    let cgImage = try imgGenerator.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: 1), actualTime: nil)
                    uiImage = UIImage(cgImage: cgImage)
                    //let imageView = UIImageView(image: uiImage)
                } catch let error {
                    print(error.localizedDescription)
                }
                let imgData = uiImage.pngData()
                print(imgData!)
                //SocketChatManager.sharedInstance.sendMsg(message: ["video": "msgData", "sentBy" : myUserId, "rid": self.groupId, "type" : "video", "name" : url.lastPathComponent, "thumbnail" : "imgData!"])
                
                // load msg to chat table
                
                let param : [String : Any] = ["video": myData, "isRead" : false, "type" : "video", "viewBy" : (self.recentChatUser?.members)!, "readBy" : myUserId, "sentAt" : "", "sentBy" : myUserId, "timeMilliSeconds" : ""]
                let param1 : [String : Any] = ["messageObj" : param, "groupId" : (self.recentChatUser?.groupId)!, "secretKey" : secretKey]
                
                if self.sendMessage(param: param1) {
                    let timestamp : Int = Int(NSDate().timeIntervalSince1970)
                    let sentAt : [String : Any] = ["seconds" : timestamp]
                    let msg : [String : Any] = ["sentBy" : myUserId,
                                                "type" : "video",
                                                "sentAt" : sentAt,
                                                "video" : urls.first!,
                                                "base64Thumbnail" : imgData!]
                    
                    if self.loadChatMsgToArray(msg: msg, timestamp: timestamp) {
                        self.tblUserChat.reloadData()
                        self.tblUserChat.scrollToRow(at: IndexPath(row: (self.arrSectionMsg![self.arrSectionMsg!.count - 1].count - 1), section: (self.arrSectionMsg!.count - 1)), at: .bottom, animated: true)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        //print(url)
        //print("\n\nOther URLs")
        //print(urls)
        //print("\n\nurl component.")
        //print(url.lastPathComponent)
        //print(url.pathExtension)
        
        controller.dismiss(animated: true)
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        print("Document picked.")
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker cancel.")
    }
}

extension UserChatVC : SocketDelegate {
    func getPreviousChatMsg(message: String) {
        print("Previous chat message.")
    }
    
    func getRecentUser(message: String) {
    }
    
    func recentChatUserList(userList: [GetUserList]) {
    }
    
    /*func msgReceived(message: String) {
        //let msg : userChat = userChat(msg: message, msgTime: Utility.currentTime(), msgDate: Utility.currentDate(), isMine: false, isImage: false)
        //arrUserChat1![keys[keys.count - 1]]?.append(msg)
        //tblUserChat.reloadData()
        //let indexPath = IndexPath(row: arrUserChat1![keys[keys.count - 1]]!.count - 1 , section: keys.count - 1)
        //tblUserChat.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }   //  */
    
    func msgReceived(message: ReceiveMessage) {
        let timestamp : Int = Int(NSDate().timeIntervalSince1970)
        //let strDate : String = Utility.convertTimestamptoDateString(timestamp: timestamp)
        var key : String = message.type!
        var value : String = ""
        if key == "image" {
            value = message.image!
        } else if key == "video" {
            value = message.video!
        } else if key == "audio" {
            value = message.audio!
        } else if key == "document" {
            value = message.document!
        } else {
            key = "message"
            value = message.msg!
        }
        let sentAt : [String : Any] = ["seconds" : timestamp]
        let msg : [String : Any] = ["sentBy" : "", //message.sentBy!,
                                    "type" : message.type!,
                                    "sentAt" : sentAt,
                                    key : value]
        
        if self.loadChatMsgToArray(msg: msg, timestamp: timestamp) {
            txtTypeMsg.text = ""
            tblUserChat.reloadData()
            tblUserChat.scrollToRow(at: IndexPath(row: (self.arrSectionMsg![arrSectionMsg!.count - 1].count - 1), section: (arrSectionMsg!.count - 1)), at: .bottom, animated: true)
        } else {
            /*let toastMsg = ToastUtility.Builder(message: "Message not send.", controller: self, keyboardActive: isKeyboardActive)
            toastMsg.setColor(background: .red, text: .black)
            toastMsg.show() //  */
        }
        
    }
}

extension UserChatVC {
    func loadChatMsgToArray(msg : [String : Any], timestamp : Int) -> Bool {
        let strDate : String = Utility.convertTimestamptoDateString(timestamp: timestamp)
        guard let responseData = try? JSONSerialization.data(withJSONObject: msg, options: []) else { return false }
        do {
            let newMsg = try JSONDecoder().decode(GetPreviousChat.self, from: responseData)
            print(newMsg)
            if (arrDtForSection?.contains(strDate))! {
                for j in 0 ..< arrDtForSection!.count {
                    if arrDtForSection![j] == strDate {
                        //arrSectionMsg?[j].append((self.arrGetPreviousChat?[i])!)
                        arrSectionMsg?[j].append(newMsg)
                    }
                }
            } else {
                var tempMsg : [GetPreviousChat] = []
                tempMsg.append(newMsg)
                arrSectionMsg?.append(tempMsg)
                arrDtForSection?.append(strDate)
            }
            return true
        } catch let err {
            print(err)
            return false
        }
        return false 
    }
}
