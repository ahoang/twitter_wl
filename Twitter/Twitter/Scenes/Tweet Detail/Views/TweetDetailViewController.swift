//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Anthony Hoang on 6/5/18.
//  Copyright © 2018 Anthony Hoang. All rights reserved.
//

import UIKit

class TweetDetailViewController: UITableViewController {

    var viewModel: TweetDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(R.nib.tweetCell(), forCellReuseIdentifier: R.reuseIdentifier.tweetCell.identifier)
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.viewModel == nil ? 0 : 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tweetCell, for: indexPath) else {
            return UITableViewCell()
        }

       cell.viewModel = self.viewModel

        return cell
    }

}
