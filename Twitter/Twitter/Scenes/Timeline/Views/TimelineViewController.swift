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
        self.tableView.register(R.nib.tweetCell(), forCellReuseIdentifier: R.reuseIdentifier.tweetCell.identifier)
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detail = R.storyboard.main.tweetDetail() else { return }
        detail.viewModel = self.viewModel.viewModelForTweet(index: indexPath.row)
        splitViewController?.showDetailViewController(detail, sender: nil)
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
        typealias DataType = AnimatableSectionModel<Section, TweetDetailViewModel>

        let dataSource = RxTableViewSectionedReloadDataSource<DataType>.init(configureCell: { (_, tableView, indexPath, viewModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tweetCell, for: indexPath) else {
                return UITableViewCell()
            }
             
            cell.viewModel = viewModel
            return cell
        })

        tableView.dataSource = nil
        self.viewModel.rx_tweets.map { (tweet) -> [DataType] in
            return [AnimatableSectionModel.init(model: .tweet, items: tweet)]
            }.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)
    }
}

extension TweetDetailViewModel: IdentifiableType {
    var identity: String {
        return self.tweet.id
    }
}
