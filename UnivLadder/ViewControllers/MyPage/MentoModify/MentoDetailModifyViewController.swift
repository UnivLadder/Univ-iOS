//
//  MentoDetailModifyViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/06/25.
//

import UIKit

class MentoDetailModifyViewController: UIViewController {

    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var textMinimumLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var saveBtn: UIButton!{
        didSet{
            saveBtn.layer.cornerRadius = 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureLayout(){
        
    }

}
