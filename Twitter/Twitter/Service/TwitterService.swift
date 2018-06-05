//
//  TwitterService.swift
//  Twitter
//
//  Created by Anthony Hoang on 6/5/18.
//  Copyright © 2018 Anthony Hoang. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

class TwitterService {

    func getDefaultUser() -> Promise<User> {
        return Promise { (resolver) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }

            let endpoint = "/api/user"
            Alamofire.request(Constants.BaseUrl + endpoint).responseJSON(completionHandler: { (response) in

                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }

                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    guard let user = User(json) else {
                        resolver.reject(TwitterErrors.GenericError)
                        return
                    }

                    resolver.fulfill(user)
                case .failure(let error):
                    resolver.reject(error)
                }
            })
        }
    }

    func getTimeLineForDefaultUser() -> Promise<[Tweet]> {
        return Promise { (resolver) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }

            let endpoint = "/api/statuses/user_timeline"
            Alamofire.request(Constants.BaseUrl + endpoint).responseJSON(completionHandler: { (response) in

                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }

                switch response.result {
                case .success(let data):
                    let json = JSON(data).array

                    guard let tweets = json?.map({ (json) -> Tweet? in
                        return Tweet(json)
                    }).compactMap({ (tweet) -> Tweet? in
                        return tweet
                    }) else {
                        resolver.reject(TwitterErrors.GenericError)
                        return
                    }

                    resolver.fulfill(tweets)
                case .failure(let error):
                    resolver.reject(error)
                }
            })
        }
    }
}

extension TwitterService {
    enum Constants {
        static let BaseUrl = "https://wizetwitterproxy.herokuapp.com"
    }
}
