//
//  FeedTableViewCell.swift
//  SnapchatClone
//
//  Created by Yasemin salan on 5.04.2025.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var feedUsernameLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
