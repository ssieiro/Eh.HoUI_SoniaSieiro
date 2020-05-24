//
//  Users.swift
//  Discourse_SoniaSieiro
//
//  Created by Sonia Sieiro on 05/04/2020.
//  Copyright © 2020 Sonia Sieiro. All rights reserved.
//

import Foundation


struct UsersListResponse: Codable {
    let directoryItems: [Users]
    enum CodingKeys: String, CodingKey {
        case directoryItems = "directory_items"
    }
}

struct Users: Codable {
    let user: User
    
}

struct User: Codable {
    let username: String
    let id: Int
    let name: String?
    let avatarTemplate: String
    
    enum CodingKeys: String, CodingKey {
        case avatarTemplate = "avatar_template"
        case id
        case username
        case name
    }
}

