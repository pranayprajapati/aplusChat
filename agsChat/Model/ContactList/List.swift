//
//  List.swift
//
//  Created by  on 10/08/22
//  Copyright (c) . All rights reserved.
//

import Foundation

struct List: Codable {
    
    enum CodingKeys: String, CodingKey {
        case userId
        case serverUserId
        case profilePicture
        case name
        case mobile_email
        case groups
    }
    
    var userId: String?
    var serverUserId: String?
    var profilePicture: String?
    var name: String?
    var mobile_email: String?
    var groups: [String]?
    var isSelected: Bool? = false
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
        serverUserId = try container.decodeIfPresent(String.self, forKey: .serverUserId)
        profilePicture = try container.decodeIfPresent(String.self, forKey: .profilePicture)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        mobile_email = try container.decodeIfPresent(String.self, forKey: .mobile_email)
        groups = try container.decodeIfPresent([String].self, forKey: .groups)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encodeIfPresent(serverUserId, forKey: .serverUserId)
        try container.encodeIfPresent(profilePicture, forKey: .profilePicture)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(mobile_email, forKey: .mobile_email)
        try container.encodeIfPresent(groups, forKey: .groups)
        
    }
}

/*struct List: Codable {
    
    enum CodingKeys: String, CodingKey {
        case username
        case email
        case lastName
        case isActive
        case firstName
        case phone
        case createdAt
        case id = "_id"
        case isSelected
    }
    
    var username: String?
    var email: String?
    var lastName: String?
    var isActive: Bool?
    var firstName: String?
    var phone: String?
    var createdAt: String?
    var id: String?
    var isSelected: Bool? = false   
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        isSelected = try container.decodeIfPresent(Bool.self, forKey: .isSelected)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(username, forKey: .username)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(isActive, forKey: .isActive)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(isSelected, forKey: .isSelected)
    }
}   //  */
