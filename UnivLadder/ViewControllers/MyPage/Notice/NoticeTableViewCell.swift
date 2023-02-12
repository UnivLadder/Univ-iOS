//
//  NoticeTableViewCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/02/12.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {

    @IBOutlet weak var announceDateLabel: UILabel!
    
    @IBOutlet weak var noticeContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        announceDateLabel.text = "23. 01. 19"
        noticeContentLabel.text = "iOS & iPadOS 16.3 Release Notes"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
