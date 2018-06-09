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
    private var user = BehaviorSubject<User?>(value: nil)
    private var tweets = BehaviorSubject<[TweetDetailViewModel]>(value: [])
    private var errorMessage = BehaviorSubject<String?>(value: nil)

    var rx_profileImage: Observable<URL?> {
        return user.map { $0?.profileImage }
    }

    var rx_backgroundImage: Observable<URL?> {
        return user.map { $0?.profileBackgroundImage }
    }

    var rx_name: Observable<String?> {
        return user.map { $0?.name }
    }

    var rx_handle: Observable<String?> {
        return user.map { "@" + ($0?.screenName ?? "") }
    }

    var rx_description: Observable<String?> {
        return user.map { $0?.details }
    }

    var rx_tweets: Observable<[TweetDetailViewModel]> {
        return tweets
    }

    var rx_Error: Observable<String?> {
        return errorMessage.asObservable()
    }

    func loadData() {
        service.getDefaultUser().done { [weak self] (user) in
            self?.user.onNext(user)
            }.catch { [weak self] (error) in
                self?.errorMessage.onNext(Constants.TweetsErrorMessage)
        }

        service.getTimeLineForDefaultUser().done { [weak self] (tweets) in
            self?.tweets.onNext(tweets.map { TweetDetailViewModel($0) })
            }.catch { [weak self] (error) in
                self?.errorMessage.onNext(Constants.ProfileErrorMessage)
        }
    }

    func viewModelForTweet(index: Int) -> TweetDetailViewModel? {
        do {
            return try self.tweets.value()[index]
        } catch {
            self.errorMessage.onNext(Constants.TweetsErrorMessage)
        }

        return nil
    }
}

extension TimelineViewModel {
    enum Constants {
        static let ProfileErrorMessage = "Oops! There was a problem loading your profile."
        static let TweetsErrorMessage = "Oops! There was a problem loading your tweets."
    }
}
