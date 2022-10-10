//
//  ProfileDetailVC.swift
//  AgsChat
//
//  Created by MAcBook on 28/05/22.
//

import UIKit
import ProgressHUD

protocol ProfileImgDelegate {
    func setProfileImg(image : UIImage)
}

class ProfileDetailVC: UIViewController {

    @IBOutlet weak var viewProfileTop: UIView!
    @IBOutlet weak var viewBackBtn: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var viewProfileImg: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnProfileImg: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    var imagePicker = UIImagePickerController()
    var profileImgDelegate : ProfileImgDelegate?
    var profileDetail : ProfileDetail?
    
    //var myUserId : String = "0"
    private var imageRequest: Cancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.profileDetail != nil {
            self.getProfileDetail(self.profileDetail!)
        } else {
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        txtUserName.delegate = self
        btnSave.layer.cornerRadius = 5 //btnSave.frame.height / 4
        
        viewProfileImg.layer.cornerRadius = viewProfileImg.frame.width / 2
        imgProfile.layer.cornerRadius = imgProfile.frame.width / 2
        btnProfileImg.layer.cornerRadius = btnProfileImg.frame.width / 2
        
        SocketChatManager.sharedInstance.profileDetailVC = {
            return self
        }
        ///["userId" : ""]
        //SocketChatManager.sharedInstance.reqProfileDetails(param: ["userId" : myUserId], from: true)
    }
    
    @IBAction func btnBackTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnProfileImgTap(_ sender: UIButton) {
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
    
    @IBAction func btnSaveTap(_ sender: UIButton) {
        if !Validations.isValidUserName(userName: txtUserName.text!) {
            // Save data
            //["userId" : "" , "name": "" , "profilePicture" : "" ]
            let imgData = imgProfile.image?.pngData()
            
            if Network.reachability.isReachable {
                if SocketChatManager.sharedInstance.socket?.status == .connected {
                    ProgressHUD.show()
                    //SocketChatManager.sharedInstance.updateProfile(param: ["userId" : myUserId , "name": txtUserName.text! , "profilePicture" : imgData! ])
                    SocketChatManager.sharedInstance.updateProfile(param: ["userId" : myUserId , "name": txtUserName.text! , "profilePicture" : imgData! ])
                }
            }
            
        } else {
            let alertWarning = UIAlertController(title: "", message: "Enter username.", preferredStyle: .alert)
            alertWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { alert in
            }))
            self.present(alertWarning, animated: true)
        }
    }
    
    func getProfileDetail(_ profileDetail : ProfileDetail) {
        print("Get response of profile details.")
        txtUserName.text = profileDetail.name!
        
        imgProfile.image = UIImage(named: "placeholder-profile-img")
        if profileDetail.profilePicture! != "" {
            imageRequest = NetworkManager.sharedInstance.getData(from: URL(string: profileDetail.profilePicture!)!) { data, resp, err in
                guard let data = data, err == nil else {
                    print("Error in download from url")
                    return
                }
                DispatchQueue.main.async {
                    let dataImg : UIImage = UIImage(data: data)!
                    self.imgProfile.image = dataImg
                }
            }
        }
    }   //  */
    
    func profileUpdate(_ isUpdate : Bool) {
        //update-profile = socket emit (request body: userId, name, profilePicture)
        //update-profile-res = socket on
        ProgressHUD.dismiss()
        if isUpdate {
            let alertWarning = UIAlertController(title: "", message: "Profile updated successfully.", preferredStyle: .alert)
            alertWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { alert in
            }))
            self.present(alertWarning, animated: true)
        } else {
            let alertWarning = UIAlertController(title: "", message: "Profile not updated.", preferredStyle: .alert)
            alertWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { alert in
            }))
            self.present(alertWarning, animated: true)
        }
    }
}
