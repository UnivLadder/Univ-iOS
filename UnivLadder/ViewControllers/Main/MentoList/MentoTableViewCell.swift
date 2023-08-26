//
//  MentoTableViewCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/06/05.
//

import UIKit

class MentoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mentoImage: UIImageView!
    @IBOutlet weak var mentoName: UILabel! {
        didSet {
            mentoName.font = Fonts.EsamanruOTF.medium.font(size: 20)
        }
    }
    @IBOutlet weak var subjectImg: UIImageView!
    @IBOutlet weak var mentoSubject: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
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
        mentoImage.layer.cornerRadius = mentoImage.bounds.width / 2
    }
}
