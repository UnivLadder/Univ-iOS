//
//  ScheduleCell.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/07/18.
//

import UIKit

class ScheduleCell: UITableViewCell {
    var colorSet: ColorSet = .main
    // scheduleCell
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    
    // fileCell
    @IBOutlet weak var fileView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSchedule() {
        circleView.layer.cornerRadius = 8
    }
    
    func setAlarm() {
        
    }
    
    func setFile() {
        fileView.layer.cornerRadius = 8
        fileView.backgroundColor = UIColor(hex: colorSet.rawValue)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
