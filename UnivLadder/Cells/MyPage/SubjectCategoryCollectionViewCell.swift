//
//  SubjectSectionCollectionViewCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/03/13.
//

import UIKit

class SubjectCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var subjectCategoryTitleLabel: UILabel!

    override var isSelected: Bool {
        willSet {
            self.subjectCategoryTitleLabel.textColor = newValue ? .black : .lightGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        isSelected = false
    }
    
    func configureCell(_ title: String) {
        self.subjectCategoryTitleLabel.text = title
    }
}
