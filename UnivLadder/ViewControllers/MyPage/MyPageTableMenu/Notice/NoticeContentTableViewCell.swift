//
//  NoticeContentTableViewCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/02/12.
//

import UIKit

class NoticeContentTableViewCell: UITableViewCell {

    @IBOutlet weak var noticeContentCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        noticeContentCellLabel.text = "Devices with a large number of installed apps will display an Apple logo with progress bar for an extended period while the file system format is updated. This is a one-time migration when upgrading to iOS 17 beta for the first time. (109431767)"
        noticeContentCellLabel.numberOfLines = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
