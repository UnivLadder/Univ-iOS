//
//  SubjectCollectionViewCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/12/04.
//

import UIKit

// 카테고리 별 과목 셀
class MetnoSubjectCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MetnoSubjectCollectionViewCell"
    
    @IBOutlet weak var mentoSubjectLabel: UILabel!{
        didSet{
            mentoSubjectLabel.numberOfLines = 2
        }
    }

//    @IBOutlet weak var subjectCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
