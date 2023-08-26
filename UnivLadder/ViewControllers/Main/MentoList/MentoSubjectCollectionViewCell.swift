//
//  MentoSubjectCollectionViewCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/06/11.
//

import Foundation
import UIKit

class MentoSubjectCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mentoSubjectTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor

//        mentoSubjectTitle.frame.size = mentoSubjectTitle.intrinsicContentSize
    }

}
