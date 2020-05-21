//
//  SingleTopic.swift
//  Discourse_SoniaSieiro
//
//  Created by Sonia Sieiro on 23/03/2020.
//  Copyright © 2020 Sonia Sieiro. All rights reserved.
//

import Foundation


struct SingleTopicResponse: Codable {
    let id: Int
    let title: String
    let postsCount: Int
    let details: Detail
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case postsCount = "posts_count"
        case details
    }
}

/*
 Mecachis, se te ha colado esta propiedad en snake_case
 */
struct Detail: Codable {
    let canDelete: Bool?
    enum CodingKeys: String, CodingKey {
        case canDelete = "can_delete"
    }
}

