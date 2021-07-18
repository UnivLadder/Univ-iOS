//
//  ScheduleCell.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/07/18.
//

import UIKit

class ScheduleCell: UITableViewCell {
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }
    
    private func setUI() {
        circleView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
