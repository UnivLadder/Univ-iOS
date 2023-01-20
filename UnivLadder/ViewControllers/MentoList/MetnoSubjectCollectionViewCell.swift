//
//  SubjectCollectionViewCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/12/04.
//

import UIKit

class MetnoSubjectCollectionViewCell: UICollectionViewCell {
    var subjectList = ["국어", "수학", "영어", "과학", "사회"]
    static let identifier = "MetnoSubjectCollectionViewCell"
    
    @IBOutlet weak var mentoSubjectLabel: UILabel!
    @IBOutlet weak var subjectCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
