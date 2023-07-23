//
//  AppInfoTableViewCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/02/12.
//

import UIKit

class AppInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var appInfoLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
