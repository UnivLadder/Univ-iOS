//
//  MentoInfoViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/01/08.
//

import UIKit

class MentoInfoViewController: UIViewController {
    //profile
    
    @IBOutlet weak var mentoImg: UIImageView!
    @IBOutlet weak var mentoNameLabel: UILabel!
    
    //star
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    
    @IBOutlet weak var thirdStar: UIImageView!
    
    @IBOutlet weak var fourthStar: UIImageView!
    
    @IBOutlet weak var fifthStar: UIImageView!
    
    
    
    var score = "3"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if score == "3"{
            firstStar.image = UIImage(systemName: "star.fill")
            secondStar.image = UIImage(systemName: "star.fill")
            secondStar.image = UIImage(systemName: "star.fill")
        }
    }

}
