//
//  GroupContactVC.swift
//  AgsChat
//
//  Created by MAcBook on 28/05/22.
//

import UIKit
import ProgressHUD

class GroupContactVC: UIViewController {

    @IBOutlet weak var viewBackCreatGrp: UIView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblCreatGroup: UILabel!
    @IBOutlet weak var viewSearchBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblContact: UITableView!
    @IBOutlet weak var btnNext: UIButton!
    
    var contactList : ContactList?
    
    //var myUserId : String = ""
    //var secretKey : String = ""
    var myContactDetail : List?
    var arrAllContactList : [List]? = []
    var arrContactList : [List]? = []
    var arrSelectedContactList : [List]? = []
    
    var groupId : String? = ""
    var isAddMember : Bool = false
    var arrGroupUserIds : [String] = []
    var arrReadCount : [[String: Any]] = []//["unreadCount":0, "userId":""]
    var arrUserIds : [String] = []
    var arrSelectedUser : [[String: Any]] = []
    var contectInfoVC : (()->ContectInfoVC)?
    var recentChatUser : GetUserList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if isAddMember {
            lblCreatGroup.text = "Add Member"
            btnNext.setTitle("Add", for: .normal)
        }
        btnNext.layer.cornerRadius = 5.0
        btnNext.isEnabled = false
        btnNext.backgroundColor = UIColor(red: 104/255.0, green: 162/255.0, blue: 254/255.0, alpha: 1)
        
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        self.searchBar.enablesReturnKeyAutomatically = true
        
        SocketChatManager.sharedInstance.groupContactVC = {
            return self
        }
        
        tblContact.dataSource = self
        tblContact.delegate = self
        
        tblContact.register(UINib(nibName: "GrpContactTVCell", bundle: nil), forCellReuseIdentifier: "GrpContactTVCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ProgressHUD.show()
        //userId, secretKey
        SocketChatManager.sharedInstance.getUserList(param: ["userId" : myUserId, "secretKey" : secretKey], from: false)
    }
    
    func getUserListRes(_ contactList : ContactList) {
        self.contactList = contactList
        self.arrAllContactList = contactList.list
        
        for i in 0 ..< (arrAllContactList!.count) {
            if (arrAllContactList![i].userId)! == myUserId {
                self.myContactDetail = arrAllContactList![i]
                arrAllContactList?.remove(at: i)
                self.contactList?.list?.remove(at: i)
                break
            }
        }
        
        if isAddMember {
            for i in 0 ..< (arrUserIds.count) {
                for j in 0 ..< (arrAllContactList!.count) {
                    if (arrAllContactList![j].userId)! == arrUserIds[i] {
                        arrAllContactList?.remove(at: j)
                        self.contactList?.list?.remove(at: j)
                        break
                    }
                }
            }
        }
        
        arrContactList = arrAllContactList
        
        tblContact.reloadData()
        ProgressHUD.dismiss()
    }
    
    @IBAction func btnBackTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextTap(_ sender: UIButton) {
        if isAddMember {
            for i in 0 ..< (arrSelectedContactList?.count ?? 0) {
                arrUserIds.append(arrSelectedContactList![i].userId ?? "")
                let contectDetail = ["userId" : arrSelectedContactList![i].userId ?? "",
                                     "serverUserId" : arrSelectedContactList![i].serverUserId ?? "",
                                     "profilePicture" : arrSelectedContactList![i].profilePicture ?? "",
                                     "name" : arrSelectedContactList![i].name ?? "",
                                     "mobile_email" : arrSelectedContactList![i].mobile_email ?? "",
                                     "groups" : arrSelectedContactList![i].groups ?? []] as [String : Any]
                arrSelectedUser.append(contectDetail)
            }
            let param = [
              "secretKey": secretKey,
              "groupId": groupId ?? "",
              "members": arrUserIds,
              "viewBy": arrUserIds,
              "users": arrSelectedUser] as [String : Any]
            
            //["groupDetails": param]
            ProgressHUD.show()
            SocketChatManager.sharedInstance.addMember(param: param)
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc =  sb.instantiateViewController(withIdentifier: "CreateGroupVC") as! CreateGroupVC
            vc.arrSelectedContactList = self.arrSelectedContactList
            vc.myContactDetail = self.myContactDetail
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func addMemberRes(_ isSuccess : Bool) {
        ProgressHUD.dismiss()
        if isSuccess {
            //self.navigationController?.popToRootViewController(animated: true)
            for i in 0 ..< (arrSelectedContactList?.count ?? 0) {
                let newUser : Users = Users(serverUserId: arrSelectedContactList![i].serverUserId ?? "", profilePicture: arrSelectedContactList![i].profilePicture ?? "", userId: arrSelectedContactList![i].userId ?? "", groups: arrSelectedContactList![i].groups ?? [], name: arrSelectedContactList![i].name ?? "", mobileEmail: arrSelectedContactList![i].mobile_email ?? "")
                recentChatUser?.users?.append(newUser)
            }
            arrSelectedContactList?.removeAll()
            contectInfoVC!().addMemberRes(userList: recentChatUser!)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
