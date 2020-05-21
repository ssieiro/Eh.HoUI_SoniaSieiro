//
//  SingleUser.swift
//  Discourse_SoniaSieiro
//
//  Created by Sonia Sieiro on 07/04/2020.
//  Copyright © 2020 Sonia Sieiro. All rights reserved.
//

import Foundation



struct SingleUserResponse: Codable {
    let user: SingleUser
}

struct SingleUser: Codable {
    let id: Int
    let username: String
    let name: String?
    let canEditName: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case canEditName = "can_edit_name"
    }
}

