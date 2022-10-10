//
//  CreateGroupVC.swift
//  agsChat
//
//  Created by MAcBook on 10/06/22.
//

import UIKit

class CreateGroupVC: UIViewController {

    @IBOutlet weak var viewBackCreateGrup: UIView!
    @IBOutlet weak var lblCreateGroup: UILabel!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewGroupImg: UIView!
    @IBOutlet weak var imgGroup: UIImageView!
    @IBOutlet weak var btnGroupImg: UIButton!
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var btnCreateGroup: UIButton!
    
    var imagePicker = UIImagePickerController()
    var myContactDetail : List?
    var arrSelectedContactList : [List]?
    var arrContactList : [[String: Any]] = []
    var arrReadCount : [[String: Any]] = []//["unreadCount":0, "userId":""]
    var arrUserIds : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtGroupName.delegate = self
        
        SocketChatManager.sharedInstance.createGroupVC = {
            return self
        }
        
        btnCreateGroup.layer.cornerRadius = 5.0
        btnCreateGroup.isEnabled = true
        btnCreateGroup.backgroundColor = UIColor(red: 15/255.0, green: 101/255.0, blue: 158/255.0, alpha: 1)
        
        viewGroupImg.layer.cornerRadius = viewGroupImg.frame.width / 2
        imgGroup.layer.cornerRadius = imgGroup.frame.width / 2
        btnGroupImg.layer.cornerRadius = btnGroupImg.frame.width / 2
        
        arrSelectedContactList?.append(myContactDetail!)
        
        for i in 0 ..< (arrSelectedContactList?.count ?? 0) {
            arrUserIds.append(arrSelectedContactList![i].userId ?? "")
            //var readCount = UnreadCount(unreadCount: 0, userId: arrSelectedContactList![i].userId ?? "")
            let readCount = ["unreadCount": 0, "userId": arrSelectedContactList![i].userId ?? ""] as [String : Any]
            arrReadCount.append(readCount)
            //var : [String]?
            let contectDetail = ["userId" : arrSelectedContactList![i].userId ?? "",
                                 "serverUserId" : arrSelectedContactList![i].serverUserId ?? "",
                                 "profilePicture" : arrSelectedContactList![i].profilePicture ?? "",
                                 "name" : arrSelectedContactList![i].name ?? "",
                                 "mobile_email" : arrSelectedContactList![i].mobile_email ?? "",
                                 "groups" : arrSelectedContactList![i].groups ?? []] as [String : Any]
            arrContactList.append(contectDetail)
        }
        //print(arrReadCount)
    }
    
    @IBAction func btnBackTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnGroupImgTap(_ sender: UIButton) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let alert = UIAlertController(title: "", message: "Please select an option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { alert in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallary", style: .default, handler: { alert in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { alert in
        }))
        self.present(alert, animated: true) {
        }
    }
    
    @IBAction func btnCreateGroupTap(_ sender: UIButton) {
        if !Validations.isEmpty(str: txtGroupName.text!) {
            let param = [
              "secretKey": secretKey,
              "isGroup": true,
              "createdBy": myUserId,
              "groupId": "",
              //"groupImage": ((imgGroup.image)?.pngData())!,
              "groupImage": "",
              "members": arrUserIds,
              "isDeactivateUser": false,
              "modifiedBy": "",
              "name": txtGroupName.text!,
              "online": [],
              "pinnedGroup": [],
              "readCount": arrReadCount,
              "typing": [],
              "blockUsers": [],
              "viewBy": arrUserIds,
              "recentMessage": [],
              "users": arrContactList] as [String : Any]
            
            SocketChatManager.sharedInstance.createGroup(param: ["groupDetails": param], from: true)
        } else {
            let alertWarning = UIAlertController(title: "", message: "Please enter group name.", preferredStyle: .alert)
            alertWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { alert in
            }))
            self.present(alertWarning, animated: true)
        }
    }
    
    func responseBack(_ isUpdate : Bool) {
        if isUpdate {
            /*for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: ViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }   //  */
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension CreateGroupVC : UITextFieldDelegate {
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count > 1 {
            btnCreateGroup.backgroundColor = UIColor(red: 15/255.0, green: 101/255.0, blue: 158/255.0, alpha: 1)
            btnCreateGroup.isEnabled = true
        } else if txtGroupName.text!.count == 1 {
            btnCreateGroup.backgroundColor = UIColor(red: 15/255.0, green: 101/255.0, blue: 158/255.0, alpha: 1)
            btnCreateGroup.isEnabled = true
        } else {
            btnCreateGroup.backgroundColor = UIColor(red: 207/255.0, green: 229/255.0, blue: 245/255.0, alpha: 1)
            btnCreateGroup.isEnabled = false
        }
        return true
    }   //  */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}

extension CreateGroupVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: "", message: "You don't have camera", preferredStyle: .alert)
            alertWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { alert in
            }))
            self.present(alertWarning, animated: true)
        }
    }
    
    func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.dismiss(animated: true) {
            }
            imgGroup.contentMode = .scaleAspectFill
            imgGroup.image = pickedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
        }
    }
}
