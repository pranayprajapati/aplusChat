//
//  ContectInfoVC.swift
//  AgsChat
//
//  Created by MAcBook on 27/05/22.
//

import UIKit
import ProgressHUD

class ContectInfoVC: UIViewController {

    @IBOutlet weak var viewMainContectInfo: UIView!
    @IBOutlet weak var viewContectInfo: UIView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblContectInfo: UILabel!
    @IBOutlet weak var viewProfilePic: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var viewDeleteChat: UIView!
    @IBOutlet weak var viewParticipants: UIView!
    @IBOutlet weak var lblParticipants: UILabel!
    @IBOutlet weak var btnAddMember: UIButton!
    @IBOutlet weak var tblParticipants: UITableView!
    @IBOutlet weak var viewExit: UIView!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var btnExit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var constraintHeightParticipants: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightViewDelete: NSLayoutConstraint!
    @IBOutlet weak var viewTblAddParticiExitGrp: UIView!
    @IBOutlet weak var constraintHeightViewTblAddParticipants: NSLayoutConstraint!
    @IBOutlet weak var constraintTopViewDelete: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomViewDelete: NSLayoutConstraint!
    @IBOutlet weak var constraintTopToUsernameViewDelete: NSLayoutConstraint!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var constraintHeighttblParticipants: NSLayoutConstraint!
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var viewScrollView: UIView!
    @IBOutlet weak var constraintHeightExitGroup: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightDeleteGroup: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomDeleteGroup: NSLayoutConstraint!
    
    //var myUserId : String = ""
    var groupId : String = ""    //  roomId
    var isAdmin : Bool = false
    var recentChatUser : GetUserList?
    var strProfileImg : String?
    var imagePicker = UIImagePickerController()
    var arrReadCount : [[String: Any]] = []//["unreadCount":0, "userId":""]
    var arrUserIds : [String] = []
    var arrSelectedUser : [[String: Any]] = []
    var strRemovedUserId : String = ""
    var userChatVC: (()->UserChatVC)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnUpdate.layer.cornerRadius = 5
        btnProfilePic.layer.cornerRadius = btnProfilePic.frame.height / 2
        
        txtUserName.delegate = self
        viewExit.isHidden = true
        viewDelete.isHidden = true
        viewTblAddParticiExitGrp.isHidden = true
        viewParticipants.isHidden = true
        constraintHeightParticipants.constant = -8
        
        SocketChatManager.sharedInstance.contectInfoVC = {
            return self
        }
        
        txtUserName.isEnabled = false
        btnUpdate.isHidden = true
        btnProfilePic.isHidden = true
        
        if (recentChatUser?.isGroup)! {
            viewExit.isHidden = false
            viewTblAddParticiExitGrp.isHidden = false
            strProfileImg = recentChatUser?.groupImage ?? ""
            
            txtUserName.text = (recentChatUser?.name)!
            txtUserName.isEnabled = false
            lblEmail.text = "\((recentChatUser?.users?.count)!) participants"
            if (recentChatUser?.createdBy)! == myUserId {
                isAdmin = true
                txtUserName.isEnabled = true
                viewDelete.isHidden = false
                btnUpdate.isHidden = false
                btnProfilePic.isHidden = false
                viewParticipants.isHidden = false
                lblParticipants.text = "\((recentChatUser?.users?.count)!) participants"
                constraintHeightParticipants.constant = 40
                btnDelete.setTitle("Delete Group", for: .normal)
                //constraintTopViewDelete.priority = .defaultHigh
            } else {
                //if (recentChatUser?.users?.count)! > 3 {
                    constraintHeightDeleteGroup.constant = 0
                    constraintBottomDeleteGroup.constant = 0
                //}
                //constraintTopViewDelete.constant = -8
                //constraintHeightViewDelete.constant = 0
            }
        } else {
            viewTblAddParticiExitGrp.isHidden = true
            
            constraintHeighttblParticipants.priority = .defaultLow
            constraintBottomDeleteGroup.priority = .defaultLow
            constraintHeightViewTblAddParticipants.priority = .required
            
            viewDelete.isHidden = false
            btnDelete.setTitle("Delete Chat", for: .normal)
            
            for i in 0 ..< (recentChatUser?.users?.count)! {
                if (recentChatUser?.users?[i].userId)! != myUserId {
                    //lblUserName.text = (recentChatUser?.users?[i].name)!
                    txtUserName.text = (recentChatUser?.users?[i].name)!
                    lblEmail.text = (recentChatUser?.users?[i].mobileEmail)!
                    strProfileImg = recentChatUser?.users?[i].profilePicture ?? ""
                }
            }
            if #available(iOS 15.0, *) {
                tblParticipants.sectionHeaderTopPadding = 0.0
            } else {
                // Fallback on earlier versions
            }
        }
        
        if strProfileImg != "" {
            NetworkManager.sharedInstance.getData(from: URL(string: strProfileImg!)!) { data, response, err in
                if err == nil {
                    DispatchQueue.main.async {
                        self.imgProfile.image = UIImage(data: data!)
                    }
                }
            }
        }
        
        tblParticipants.dataSource = self
        tblParticipants.delegate = self
        tblParticipants.register(UINib(nibName: "ParticipantsTVCell", bundle: nil), forCellReuseIdentifier: "ParticipantsTVCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        viewProfilePic.layer.cornerRadius = viewProfilePic.frame.width / 2
        imgProfile.layer.cornerRadius = imgProfile.frame.width / 2
        imgProfile.backgroundColor = .cyan
        
        self.constraintHeighttblParticipants.constant = CGFloat((self.recentChatUser?.users?.count)! * 70)
        self.viewScrollView.layoutIfNeeded()
    }
    
    @IBAction func btnBackTap(_ sender: UIButton) {
        userChatVC!().memberRemoveRes(true, updatedRecentChatUser: recentChatUser!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddMemberTap(_ sender: UIButton) {
        arrSelectedUser.removeAll()
        arrUserIds.removeAll()
        for i in 0 ..< (recentChatUser?.users!.count)! {
            arrUserIds.append((recentChatUser?.users![i].userId)!)
            let contectDetail = ["userId" : recentChatUser?.users![i].userId ?? "",
                                 "serverUserId" : recentChatUser?.users![i].serverUserId ?? "",
                                 "profilePicture" : recentChatUser?.users![i].profilePicture ?? "",
                                 "name" : recentChatUser?.users![i].name ?? "",
                                 "mobile_email" : recentChatUser?.users![i].mobileEmail ?? "",
                                 "groups" : recentChatUser?.users![i].groups ?? []] as [String : Any]
            arrSelectedUser.append(contectDetail)
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc =  sb.instantiateViewController(withIdentifier: "GroupContactVC") as! GroupContactVC
        vc.arrUserIds = arrUserIds
        vc.arrSelectedUser = arrSelectedUser
        vc.isAddMember = true
        vc.groupId = groupId
        vc.recentChatUser = recentChatUser
        vc.contectInfoVC = { return self }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnExitDeleteTap(_ sender: UIButton) {
        if sender.tag == 0 {
            // 0 for Exit
            if (recentChatUser?.isGroup)! {
                //(groupId, userId)
                let alertController = UIAlertController(title: "Are you sure you want to exit group ?", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                    ProgressHUD.show()
                    SocketChatManager.sharedInstance.exitGroup(param: ["userId" : myUserId, "groupId" : self.groupId])
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
                }
                alertController.addAction(OKAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        } else if sender.tag == 1 {
            // 1 for Delete
            if (recentChatUser?.isGroup)! {
                let alertController = UIAlertController(title: "Are you sure you want to delete group ?", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                    //Delete group
                    ProgressHUD.show()
                    SocketChatManager.sharedInstance.deleteGroup(param: ["userId" : myUserId, "groupId" : self.groupId], from: false)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
                }
                alertController.addAction(OKAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Are you sure you want to delete chat ?", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                    //Delete chat
                    ProgressHUD.show()
                    SocketChatManager.sharedInstance.deleteChat(param: ["userId" : myUserId, "groupId" : self.groupId], from: false)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
                }
                alertController.addAction(OKAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func responseBack(_ isUpdate : Bool) {
        ProgressHUD.dismiss()
        if isUpdate {
            /*let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc =  sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.popToViewController(vc, animated: true)  //  */
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func btnUpdateTap(_ sender: UIButton) {
        let param = ["groupId" : groupId, "name" : txtUserName.text!, "profilePicture" : ""]
        
        ProgressHUD.show()
        SocketChatManager.sharedInstance.updateGroup(param: param)
    }
    
    func profileUpdateRes(_ isUpdate : Bool) {
        if isUpdate {
            ProgressHUD.dismiss()
            
            let alertController = UIAlertController(title: "Profile updated successfully.", message: "", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                //Update profile.
                //self.navigationController?.popToRootViewController(animated: true)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func addMemberRes(userList : GetUserList) {
        recentChatUser = userList
        lblEmail.text = "\((recentChatUser?.users?.count)!) participants"
        lblParticipants.text = "\((recentChatUser?.users?.count)!) participants"
        self.tblParticipants.reloadData()
        
        DispatchQueue.main.async {
            self.constraintHeighttblParticipants.constant = self.tblParticipants.contentSize.height
            self.updateViewConstraints()
        }
    }
    
    @IBAction func btnProfilePicTap(_ sender: UIButton) {
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
}

extension ContectInfoVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: "", message: "Camera not available.", preferredStyle: .alert)
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
            imgProfile.contentMode = .scaleAspectFill
            imgProfile.image = pickedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
        }
    }
}

extension ContectInfoVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}
