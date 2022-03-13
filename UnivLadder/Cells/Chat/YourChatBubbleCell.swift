//
//  YourChatBubbleCell.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/05/09.
//

import UIKit

class YourChatBubbleCell: UITableViewCell {
    static let identifier: String = "YourChatBubbleCell"
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.backgroundColor = Theme.light500
            profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        }
    }
//
    @IBOutlet weak var bubbleView: UIView! {
        didSet {
            bubbleView.backgroundColor = Theme.light300
            bubbleView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var bubbleLabel: UILabel! {
        didSet {
            bubbleLabel.textColor = Theme.labelColor
            bubbleLabel.font = Fonts.EsamanruOTF.light.font(size: 14)
            bubbleLabel.text = "테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트"
            
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.textColor = Theme.text1000
            timeLabel.font = Fonts.GmarketSans.medium.font(size: 12)
            timeLabel.text = "12:30"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
