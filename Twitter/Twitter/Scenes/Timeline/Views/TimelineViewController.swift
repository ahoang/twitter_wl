//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Anthony Hoang on 6/5/18.
//  Copyright © 2018 Anthony Hoang. All rights reserved.
//

import UIKit
import SDWebImage

class TimelineViewController: UITableViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var profileAvatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    let service = TwitterService()
    var tweets = [Tweet]()
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        service.getTimeLineForDefaultUser().done { [weak self] (tweets) in
            self?.tweets = tweets
            self?.tableView.reloadData()
            }.catch { (error) in
        }

        service.getDefaultUser().done { [weak self] (user) in
            self?.descriptionlabel.text = user.details
            self?.nameLabel.text = user.name
            self?.handleLabel.text = user.screenName
            self?.profileAvatar.sd_setImage(with: user.profileImage, completed:nil)
            self?.backgroundImageView.sd_setImage(with: user.profileBackgroundImage, completed: nil)
            }.catch { (error) in

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tweets.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as? TweetCell else {
            return UITableViewCell()
        }

        let tweet = self.tweets[indexPath.row]
        cell.tweetLabel.text = tweet.text
        cell.handleLabel.text = "@" + tweet.user.screenName
        cell.nameLabel.text = tweet.user.name
        cell.avatarImageView.sd_setImage(with: tweet.user.profileImage, completed: nil)

        return cell
    }

}
