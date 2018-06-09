//
//  TweetDetailViewModel.swift
//  Twitter
//
//  Created by Anthony Hoang on 6/5/18.
//  Copyright © 2018 Anthony Hoang. All rights reserved.
//

import Foundation

class TweetDetailViewModel: Equatable {

    let tweet: Tweet
    var text: String {
        return tweet.text
    }

    var handle: String {
        return "@" + tweet.user.screenName
    }

    var name: String {
        return "THIS IS A REALLY REALLY REALLY REALLY REALLY REALLY REALLY LONG NAME"
    }

    var avatar: URL {
        return tweet.user.profileImage
    }

    var date: String  {
        return tweet.createdAt.shortTimeAgoSinceNow
    }

    init(_ tweet: Tweet) {
        self.tweet = tweet
    }

    static func == (lhs: TweetDetailViewModel, rhs: TweetDetailViewModel) -> Bool {
        return lhs.tweet == rhs.tweet
    }
}
