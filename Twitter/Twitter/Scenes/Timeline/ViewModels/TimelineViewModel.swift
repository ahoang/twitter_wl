//
//  TimelineViewModel.swift
//  Twitter
//
//  Created by Anthony Hoang on 6/5/18.
//  Copyright © 2018 Anthony Hoang. All rights reserved.
//

import Foundation
import RxSwift

class TimelineViewModel {

    private var service = TwitterService()
    private var user = Variable<User?>(nil)
    private var tweets = Variable<[TweetDetailViewModel]>([])
    private var errorMessage = Variable<String?>(nil)

    var rx_profileImage: Observable<URL?> {
        return user.asObservable().map { $0?.profileImage }
    }

    var rx_backgroundImage: Observable<URL?> {
        return user.asObservable().map { $0?.profileBackgroundImage }
    }

    var rx_name: Observable<String?> {
        return user.asObservable().map { $0?.name }
    }

    var rx_handle: Observable<String?> {
        return user.asObservable().map { $0?.screenName }
    }

    var rx_description: Observable<String?> {
        return user.asObservable().map { $0?.details }
    }

    var rx_tweets: Observable<[TweetDetailViewModel]> {
        return tweets.asObservable()
    }

    var rx_Error: Observable<String?> {
        return errorMessage.asObservable()
    }

    func loadData() {
        service.getDefaultUser().done { [weak self] (user) in
            self?.user.value = user
            }.catch { [weak self] (error) in
                self?.errorMessage.value = Constants.ProfileErrorMessage
        }

        service.getTimeLineForDefaultUser().done { [weak self] (tweets) in
            self?.tweets.value = tweets.map { TweetDetailViewModel($0) }
            }.catch { [weak self] (error) in
                self?.errorMessage.value = Constants.TweetsErrorMessage
        }
    }

    func viewModelForTweet(index: Int) -> TweetDetailViewModel {
        return self.tweets.value[index]
    }
}

extension TimelineViewModel {
    enum Constants {
        static let ProfileErrorMessage = "Oops! There was a problem loading your profile."
        static let TweetsErrorMessage = "Oops! There was a problem loading your tweets."
    }
}
