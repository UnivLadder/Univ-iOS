//
//  SubjectCollectionViewCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/03/06.
//

import UIKit

class SubjectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subjectLabel: UILabel!
    
    @IBOutlet weak var subjectContentView: UIView!
 
    func settingCellContentView()  {
        self.subjectContentView.layer.cornerRadius = 2.0
        self.subjectContentView.layer.borderWidth = 1.0
        self.subjectContentView.layer.borderColor = UIColor.black.cgColor
    }
}
