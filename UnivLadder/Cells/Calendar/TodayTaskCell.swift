//
//  TodayTaskCell.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/07/11.
//

import UIKit

class TodayTaskCell: UITableViewCell {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var subjectDetailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }
    
    func configure(isFirst: Bool, isLast: Bool, subject: String, detail: String) {
        if isFirst {
            topLine.isHidden = true
        } else if isLast {
            bottomLine.isHidden = true
        }
        subjectLabel.text = subject
        subjectDetailLabel.text = detail
    }
    
    private func setUI() {
        circleView.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
