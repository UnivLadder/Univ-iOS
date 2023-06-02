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
        noticeContentCellLabel.text = "BLAH BLAH BLAH BLAH BLAH"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
