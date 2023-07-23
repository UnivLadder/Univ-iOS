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
                   self.subjectContentView.layer.borderColor = #colorLiteral(red: 0.4261336327, green: 0.352904737, blue: 0.9019818306, alpha: 1)
               }
               else {
                   self.subjectContentView.layer.borderColor = UIColor.lightGray.cgColor
               }
           }
       }
       
}
