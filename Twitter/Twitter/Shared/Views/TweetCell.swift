//
//  TweetCell.swift
//  Twitter
//
//  Created by Anthony Hoang on 6/5/18.
//  Copyright © 2018 Anthony Hoang. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var viewModel: TweetDetailViewModel? {
        didSet {
            self.tweetLabel.text = self.viewModel?.text
            self.handleLabel.text = self.viewModel?.handle
            self.nameLabel.text = self.viewModel?.name
            self.avatarImageView.sd_setImage(with: self.viewModel?.avatar, completed: nil)
            self.dateLabel.text = self.viewModel?.date
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.avatarImageView.layer.cornerRadius = 50 / 2
        self.avatarImageView.layer.borderColor = UIColor.black.cgColor
        self.avatarImageView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
