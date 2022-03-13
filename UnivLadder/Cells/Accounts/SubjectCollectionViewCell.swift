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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.subjectContentView.layer.cornerRadius = 10.0
        self.subjectContentView.layer.borderWidth = 1.0
        self.subjectContentView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override var isSelected: Bool {
           didSet{
               if isSelected {
                   self.subjectContentView.layer.borderColor = UIColor.red.cgColor
               }
               else {
                   self.subjectContentView.layer.borderColor = UIColor.lightGray.cgColor
               }
           }
       }
       
}
