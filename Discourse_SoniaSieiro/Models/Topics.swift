//
//  Topics.swift
//  Discourse_SoniaSieiro
//
//  Created by Sonia Sieiro on 19/03/2020.
//  Copyright © 2020 Sonia Sieiro. All rights reserved.
//

import Foundation

struct LatestTopicsResponse: Codable {
    let topicList: TopicList
    let users: [User]
    enum CodingKeys: String, CodingKey {
        case topicList = "topic_list"
        case users
    }
}


struct TopicList: Codable {
    let topics: [Topic]
}

struct Topic: Codable {
    let id: Int
    let title: String
    let postsCount: Int
    let lastPostedAt: String
    let lastPosterUsername: String
    let posters: [Poster]
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case postsCount = "posts_count"
        case lastPostedAt = "last_posted_at"
        case posters
        case lastPosterUsername = "last_poster_username"
    }
}

struct Poster: Codable {
    let description: String
    let user_id: Int
}
