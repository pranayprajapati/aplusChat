//
//  ChatModel.swift
//  agsChat
//
//  Created by MAcBook on 10/06/22.
//

import Foundation

/*struct recentChatList : Codable {
 //{ secretKey : '' , _id: ''}
 var secretKey : String?
 var _id : String?
 }   //  */

//["msg": videoD!, "rid": self.groupId, "type" : "video", "name" : (videoUrl?.lastPathComponent)!, "thumbnail" : imgData!]
struct ReceiveMessage: Codable {
    var msg : String?
    var thumbnail : String?
    var sentBy : String?
    var rid : String?
    var type : String?
    var name : String?
    var image : String?
    var document : String?
    var audio : String?
    var video : String?
}

struct ProfileDetail: Codable {
    let mobileEmail, name, profilePicture, userID: String?
    
    enum CodingKeys: String, CodingKey {
        case mobileEmail = "mobile_email"
        case name, profilePicture
        case userID = "userId"
    }
}

struct reqResponse: Codable {
    let isSuccess: Bool?
    let msg: String?
}

struct UnreadCount {
    var unreadCount: Int
    var userId:String
}
