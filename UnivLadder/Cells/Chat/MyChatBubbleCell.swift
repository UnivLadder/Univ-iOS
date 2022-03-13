//
//  MyChatBubbleCell.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/12/20.
//

import UIKit

class MyChatBubbleCell: UITableViewCell {
    static let identifier = "MyChatBubbleCell"
    
    @IBOutlet weak var bubbleView: UIView! {
        didSet {
            bubbleView.backgroundColor = Colors.main.color
            bubbleView.layer.cornerRadius = Constant.cornerRadius
        }
    }

    @IBOutlet weak var bubbleLabel: UILabel! {
        didSet {
            bubbleLabel.textColor = Theme.whiteColor
            bubbleLabel.font = Theme.esamanru14Light
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.textColor = Theme.text1000
            timeLabel.font = Theme.gmarketSans12Medium
            timeLabel.text = "12:30"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
