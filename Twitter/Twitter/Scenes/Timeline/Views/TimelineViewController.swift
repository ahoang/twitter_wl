//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Anthony Hoang on 6/5/18.
//  Copyright © 2018 Anthony Hoang. All rights reserved.
//

import UIKit
import SDWebImage
import DateToolsSwift
import RxSwift
import RxCocoa
import RxDataSources

class TimelineViewController: UITableViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var profileAvatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private let viewModel = TimelineViewModel()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bindTableData()
        self.viewModel.loadData()
        self.viewModel.rx_name.bind(to: self.nameLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.rx_handle.bind(to: self.handleLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.rx_description.bind(to: self.descriptionlabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.rx_profileImage.bind { [weak self] (url) in
            self?.profileAvatar.sd_setImage(with: url, completed: nil)
        }.disposed(by: self.disposeBag)
        self.viewModel.rx_backgroundImage.bind { [weak self] (url) in
            self?.backgroundImageView.sd_setImage(with: url, completed: nil)
        }.disposed(by: self.disposeBag)
    }

}

extension TimelineViewController {
    enum Section: Int, IdentifiableType {
        case tweet

        var identity: Int {
            return self.rawValue
        }
    }

    func bindTableData() {
        typealias DataType = AnimatableSectionModel<Section, Tweet>

        let dataSource = RxTableViewSectionedReloadDataSource<DataType>.init(configureCell: { (_, tableView, indexPath, tweet) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as? TweetCell else {
                return UITableViewCell()
            }

            cell.tweetLabel.text = tweet.text
            cell.handleLabel.text = "@" + tweet.user.screenName
            cell.nameLabel.text = tweet.user.name
            cell.avatarImageView.sd_setImage(with: tweet.user.profileImage, completed: nil)
            cell.dateLabel.text = tweet.createdAt.shortTimeAgoSinceNow

            return cell
        })

        tableView.dataSource = nil
        self.viewModel.rx_tweets.map { (tweet) -> [DataType] in
            return [AnimatableSectionModel.init(model: .tweet, items: tweet)]
            }.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)
    }
}

extension Tweet: IdentifiableType {
    var identity: String {
        return self.id
    }
}
