//
//  ViewController.swift
//  AgsChat
//
//  Created by MAcBook on 27/05/22.
//

import UIKit
import SocketIO
import ProgressHUD

var secretKey : String = "U2FsdGVkX18AsTXTniJJwZ9KaiRWQki0Gike3TN%2BQyXws0hyLIdcRN4abTk84a7r"
var myUserId : String = "6271005aa0b24b24eb781674"      // My id
//var myUserId : String = "6270fff1b2000e317f955d75"      //another user id for chat -
//var myUserId : String = ""      //another user id for chat -

class ViewController: UIViewController {

    @IBOutlet weak var viewTopChatGrp: UIView!
    @IBOutlet weak var tblChatList: UITableView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var btnNewChat: UIButton!
    @IBOutlet weak var btnNewGroupChat: UIButton!
    @IBOutlet weak var btnViewUserProfile: UIButton!
    @IBOutlet weak var viewSearchBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var userName : String = "ABC"
    var isNetworkAvailable : Bool = false
    var isGetUserList : Bool = false
    var arrAllRecentChatUserList : [GetUserList]? = []
    var arrRecentChatUserList : [GetUserList]? = []
    private var imageRequest: Cancellable?
    var profileDetail : ProfileDetail?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SocketChatManager.sharedInstance.establishConnection()
        SocketChatManager.sharedInstance.viewController = {
            return self
        }
        
        imgProfilePic.image = UIImage(named: "placeholder-profile-img")
        
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        self.searchBar.enablesReturnKeyAutomatically = true
        
        tblChatList.dataSource = self
        tblChatList.delegate = self
        
        tblChatList.register(UINib(nibName: "UserDetailTVCell", bundle: nil), forCellReuseIdentifier: "UserDetailTVCell")
        
        if Network.reachability.isReachable {
            isNetworkAvailable = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(checkConnection), name: .flagsChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.height / 2
        SocketChatManager.sharedInstance.socketDelegate = self
        isGetUserList = false
        
        if (SocketChatManager.sharedInstance.socket?.status == .connected) {
            isGetUserList = true
            SocketChatManager.sharedInstance.reqProfileDetails(param: ["userId" : myUserId], from: false)
            SocketChatManager.sharedInstance.reqRecentChatList(param: ["secretKey" : secretKey, "_id" : myUserId])
        }
    }
    
    @objc func checkConnection(_ notification: Notification) {
        updateUserInterface()
    }
    
    func updateUserInterface() {
        switch Network.reachability.isReachable {
        case true:
            if !self.isNetworkAvailable {
                self.isNetworkAvailable = true
                let toastMsg = ToastUtility.Builder(message: "Network available.", controller: self, keyboardActive: false)
                toastMsg.setColor(background: .green, text: .black)
                toastMsg.show()
            }
            print("Network connection available.")
            break
        case false:
            if isNetworkAvailable {
                self.isNetworkAvailable = false
                let toastMsg = ToastUtility.Builder(message: "No Network.", controller: self, keyboardActive: false)
                toastMsg.setColor(background: .red, text: .black)
                toastMsg.show()
            }
            SocketChatManager.sharedInstance.establishConnection()
            break
        }
    }
    
    @IBAction func btnViewUserProfileTap(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc =  sb.instantiateViewController(withIdentifier: "ProfileDetailVC") as! ProfileDetailVC
        vc.profileImgDelegate = self
        vc.profileDetail = self.profileDetail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnNewChatTap(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc =  sb.instantiateViewController(withIdentifier: "ContactListVC") as! ContactListVC
        vc.arrRecentChatUserList = arrAllRecentChatUserList
        self.navigationController?.pushViewController(vc, animated: true)   //  */
    }
    
    @IBAction func btnNewGroupChatTap(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc =  sb.instantiateViewController(withIdentifier: "GroupContactVC") as! GroupContactVC
        self.navigationController?.pushViewController(vc, animated: true)   //  */
    }
    
    func getProfileDetail(_ profileDetail : ProfileDetail) {
        ProgressHUD.dismiss()
        print("Get response of profile details.")
        self.profileDetail = profileDetail
        imgProfilePic.image = UIImage(named: "placeholder-profile-img")
        if profileDetail.profilePicture! != "" {
            imageRequest = NetworkManager.sharedInstance.getData(from: URL(string: profileDetail.profilePicture!)!) { data, resp, err in
                guard let data = data, err == nil else {
                    print("Error in download from url")
                    return
                }
                DispatchQueue.main.async {
                    let dataImg : UIImage = UIImage(data: data)!
                    self.imgProfilePic.image = dataImg
                }
            }
        }   //  */
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRecentChatUserList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailTVCell", for: indexPath) as! UserDetailTVCell
        var msgType : String = ""
        if (self.arrRecentChatUserList?[indexPath.row].recentMessage?.type != nil) {
            msgType = (self.arrRecentChatUserList?[indexPath.row].recentMessage?.type)!
        }
        
        if (self.arrRecentChatUserList?[indexPath.row].isGroup)! {
            cell.configure((self.arrRecentChatUserList?[indexPath.row].name)!, self.arrRecentChatUserList?[indexPath.row].groupImage ?? "", msgType)
        } else {
            for (_, item) in ((self.arrRecentChatUserList?[indexPath.row].users)!).enumerated() {
                if (item.userId)! != myUserId {
                    cell.configure(item.name ?? "", item.profilePicture ?? "", msgType)
                }
            }
        }
        
        cell.imgProfile.image = UIImage(named: "placeholder-profile-img")
        
        if msgType == "text" {
            cell.lblLastMsg.text = (self.arrRecentChatUserList?[indexPath.row].recentMessage?.message)!
        } else if msgType == "" {
            cell.lblLastMsg.text = "Start your conversation"
        }
        
        //cell.lblMsgDateTime.text = "\((self.arrRecentChatUserList?[indexPath.row].recentMessage?.sentAt?.seconds)!)"
        if msgType != "" {
            cell.lblMsgDateTime.text = Utility.convertTimestamptoLastMsgDateTimeString(timestamp: "\((self.arrRecentChatUserList?[indexPath.row].recentMessage?.sentAt?.seconds)!)")
        }
        
        cell.lblUnreadMsgCount.isHidden = true
        for (_, item) in ((self.arrRecentChatUserList?[indexPath.row].readCount)!).enumerated() {
            if item.userId == myUserId && item.unreadCount! != 0 {
                cell.lblUnreadMsgCount.isHidden = false
                cell.lblUnreadMsgCount.text = String(describing: item.unreadCount!)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc =  sb.instantiateViewController(withIdentifier: "UserChatVC") as! UserChatVC
        //vc.myUserId = myUserId
        vc.recentChatUser = self.arrRecentChatUserList?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController : UISearchBarDelegate, ProfileImgDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.arrRecentChatUserList = self.arrAllRecentChatUserList?.filter{ ($0.name?.lowercased().prefix(searchText.count))! == searchText.lowercased() }
        print(searchText)
        self.tblChatList.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.arrRecentChatUserList = self.arrAllRecentChatUserList
        self.searchBar.text = ""
        self.tblChatList.reloadData()
    }
    
    func setProfileImg(image: UIImage) {
        imgProfilePic.contentMode = .scaleAspectFill
        imgProfilePic.image = image
    }
}

extension ViewController : SocketDelegate {
    func msgReceived(message: ReceiveMessage) {
    }
    
    func getPreviousChatMsg(message: String) {
    }
    
    func recentChatUserList(userList: [GetUserList]) {
        self.arrAllRecentChatUserList = userList
        self.arrRecentChatUserList = self.arrAllRecentChatUserList
        tblChatList.reloadData()
        //ProgressHUD.dismiss()
    }
    
    func getRecentUser(message: String) {
        print(message)
        
        if (SocketChatManager.sharedInstance.socket?.status == .connected) {
            isGetUserList = true
            //ProgressHUD.show()
            SocketChatManager.sharedInstance.reqProfileDetails(param: ["userId" : myUserId], from: false)
            //  ["secretKey" : secretKey, "_id" : myUserId]
            SocketChatManager.sharedInstance.reqRecentChatList(param: ["secretKey" : secretKey, "_id" : myUserId])
        }
    }
}
