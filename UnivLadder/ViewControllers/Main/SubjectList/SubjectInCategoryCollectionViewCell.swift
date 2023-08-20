//
//  SubjectInCategoryCollectionViewCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/06/05.
//

import UIKit

class SubjectInCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var subjectTitleLabel: UILabel!

    override var isSelected: Bool {
        willSet {
//            self.subjectTitleLabel.textColor = newValue ? .black : .lightGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subjectTitleLabel.frame.size = subjectTitleLabel.intrinsicContentSize
    }
    
    override func prepareForReuse() {
        isSelected = false
    }
    
    func configureCell(_ title: String) {
        self.subjectTitleLabel.text = title
    }
}
