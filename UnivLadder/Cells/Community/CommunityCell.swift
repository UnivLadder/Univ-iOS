//
//  CommunityCell.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/10/10.
//

import UIKit

class CommunityCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }
    
    private func setUI() {
        containerView.sizeToFit()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
