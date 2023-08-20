//
//  ChatRoomListCell.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/05/09.
//

import UIKit

class ChatRoomListCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = Fonts.EsamanruOTF.medium.font(size: 16)
//            nameLabel.text = "이름"
        }
    }
    @IBOutlet weak var lastMessageLabel: UILabel! {
        didSet {
            lastMessageLabel.font = Fonts.EsamanruOTF.light.font(size: 13)
            lastMessageLabel.textColor = Colors.Text.text300.color
//            lastMessageLabel.text = "마지막 메세지"
        }
    }
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.font = Theme.numberFont
            timeLabel.textColor = Colors.Text.text300.color
//            timeLabel.text = "10:32"
        }
    }
    @IBOutlet weak var messageCountView: UIView! {
        didSet {
            messageCountView.backgroundColor = Colors.Red.red500.color
        }
    }
    
    @IBOutlet weak var messageCountLabel: UILabel! {
        didSet {
            messageCountLabel.font = Theme.numberFont
            messageCountLabel.textColor = Theme.whiteColor
            messageCountLabel.textAlignment = .center
            messageCountLabel.text = "0"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI() {
        messageCountView.layer.cornerRadius = messageCountView.bounds.width / 2
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
//        profileImageView.backgroundColor = .lightGray
    }

}
