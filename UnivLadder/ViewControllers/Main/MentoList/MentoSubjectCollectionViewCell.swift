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
        mentoSubjectTitle.frame.size = mentoSubjectTitle.intrinsicContentSize
    }

}
