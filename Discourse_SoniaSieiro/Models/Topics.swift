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
    enum CodingKeys: String, CodingKey {
        case topicList = "topic_list"
    }
}


struct TopicList: Codable {
    let topics: [Topic]
}

struct Topic: Codable {
    let id: Int
    let title: String

}
