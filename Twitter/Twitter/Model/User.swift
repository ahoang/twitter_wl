//
//  User.swift
//  Twitter
//
//  Created by Anthony Hoang on 6/5/18.
//  Copyright © 2018 Anthony Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    let id: Int
    let name: String
    let screenName: String
    let location: String
    let details: String
    let followersCount: Int
    let friendsCount: Int
//    let createdAt: Date?
    let backgroundColor: String
    let profileBackgroundImage: URL
    let profileImage: URL
    let profileBanner: URL

    init?(_ json: JSON) {
        guard let id = json["id"].int,
            let name = json["name"].string,
            let screenName = json["screen_name"].string,
            let location = json["location"].string,
            let description = json["description"].string,
            let followersCount = json["followers_count"].int,
            let friendsCount = json["friends_count"].int,
            let createdAtString = json["created_at"].string,
            let backgroundColor = json["profile_background_color"].string,
            let profileBGImagestring = json["profile_background_image_url"].string,
            let profileBackgroundImageURL = URL(string: profileBGImagestring),
            let profileImageString = json["profile_image_url"].string,
            let profileImageURL = URL(string: profileImageString),
            let profileBannerString = json["profile_banner_url"].string,
            let profileBannerURL = URL(string: profileBannerString) else {
            return nil
        }

        self.id = id
        self.name = name
        self.screenName = screenName
        self.location = location
        self.details = description
        self.followersCount = followersCount
        self.friendsCount = friendsCount
//        self.createdAt =
        self.backgroundColor = backgroundColor
        self.profileBackgroundImage = profileBackgroundImageURL
        self.profileImage = profileImageURL
        self.profileBanner = profileBannerURL

    }
}
