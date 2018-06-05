//
//  Tweet.swift
//  Twitter
//
//  Created by Anthony Hoang on 6/5/18.
//  Copyright © 2018 Anthony Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Tweet: Equatable {

    let id: String
    let text: String
    let createdAt: Date
    let truncated: Bool
    let hashtags: [String]
    let urls: [String]
    let userMentions: [String]
    let user: User

    init?(_ json: JSON) {
        guard let id = json["id_str"].string,
            let createdAtString = json["created_at"].string,
            let createdAt = DateFormatter.twitterDateFormatter.date(from: createdAtString),
            let text = json["text"].string,
            let truncated = json["truncated"].bool,
            let entities = json["entities"].dictionary,
            let hashtags = entities["hashtags"]?.array,
            let urls = entities["urls"]?.array,
            let userMentions = entities["user_mentions"]?.array,
            let userInfo = User(json["user"]) else {
            return nil
        }

        self.id = id
        self.createdAt = createdAt
        self.text = text
        self.truncated = truncated
        self.hashtags = hashtags.map{ $0.string }.compactMap { $0 }
        self.userMentions = userMentions.map{ $0.string}.compactMap{$0}
        self.urls = urls.map{ $0.string }.compactMap{ $0 }
        self.user = userInfo
    }

    static func == (lhs: Tweet, rhs: Tweet) -> Bool {
        return lhs.id == rhs.id
    }
}
