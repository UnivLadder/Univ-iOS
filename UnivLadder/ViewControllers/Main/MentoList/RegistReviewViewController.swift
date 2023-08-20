//
//  RegistReviewViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/08/06.
//

import UIKit
import Cosmos
import Alamofire

class RegistReviewViewController: UIViewController {
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.text = "별점을 등록해주세요!"
            titleLabel.font = Fonts.EsamanruOTF.medium.font(size: 20)
        }
    }
    
    @IBOutlet weak var textLabel: UILabel!{
        didSet{
            textLabel.text = "리뷰를 작성해주세요!"
            textLabel.font = Fonts.EsamanruOTF.medium.font(size: 20)
        }
    }
    
    @IBOutlet weak var reviewTextField: UITextField!
    
    @IBOutlet weak var senderBtn: UIButton!
    
    var mentoId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "리뷰 등록"
        hideKeyboardWhenTappedAround()
        senderBtn.layer.cornerRadius = 10
        senderBtn.tintColor = UIColor.white
        senderBtn.setTitle(NSLocalizedString("registerReview", comment: ""), for: .normal)
        senderBtn.titleLabel?.font = Fonts.EsamanruOTF.medium.font(size: 20)
    }
    
    @IBAction func sendReview(_ sender: Any) {
        let score = ratingView.rating
        if let mentoId = mentoId,
           let review = reviewTextField.text,
           let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            
            let parameter: Parameters = [
                "mentorId" : mentoId,
                "comment" : review,
                "score" : score ]
            APIService.shared.registerMentoReview(accessToken: accessToken, param: parameter, completion: { res in
                var alert = UIAlertController()
                if res{
                    alert = UIAlertController(title:"⭐️리뷰 성공⭐️",
                                                  message: "리뷰를 등록 완료했습니다",
                                                  preferredStyle: UIAlertController.Style.alert)

                }else{
                    alert = UIAlertController(title:"👿리뷰 등록 실패👿",
                                                  message: "리뷰 등록에 실패했습니다",
                                                  preferredStyle: UIAlertController.Style.alert)
                }
                let buttonLabel = UIAlertAction(title: "확인", style: .default, handler: {_ in
                    self.dismiss(animated:true, completion: nil)
                })
                alert.addAction(buttonLabel)
                self.present(alert,animated: true,completion: nil)
                return 0
            })
        }
    }
}
