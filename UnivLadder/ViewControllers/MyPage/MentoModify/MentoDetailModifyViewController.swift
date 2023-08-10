//
//  MentoDetailModifyViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/06/25.
//

import UIKit
import Alamofire
import MultiSlider

class MentoDetailModifyViewController: UIViewController, UITextViewDelegate {
    
    let textViewPlaceHolder = "서비스에 대해 상세하게 설명해주세요.(최대 50자)"
    
    @IBOutlet weak var sliderView: MultiSlider!{
        didSet{
            sliderView.valueLabelPosition = .top
            sliderView.keepsDistanceBetweenThumbs = true
            sliderView.value = [10000, 400000]
            sliderView.snapStepSize = 1000
            sliderView.valueLabelTextForThumb = { thumbIndex, thumbValue in
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let result = numberFormatter.string(from: NSNumber(value: Int(round(thumbValue))))!
                
                return "\(result)" + "원"
            }
        }
    }
    
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!{
        didSet{
            detailTextView.text = textViewPlaceHolder
            detailTextView.textColor = .lightGray
        }
    }
    
    @IBOutlet weak var saveBtn: UIButton!{
        didSet{
            saveBtn.layer.cornerRadius = 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        detailTextView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if detailTextView.text.isEmpty {
            detailTextView.text = textViewPlaceHolder
            detailTextView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if detailTextView.textColor == UIColor.lightGray {
            detailTextView.text = nil // 텍스트를 날려줌
            detailTextView.textColor = UIColor.black
        }
    }
    
    @IBAction func modifyMentoDescription(_ sender: Any) {
        let parameter: Parameters = [
            "fcmToken" : UserDefaults.standard.string(forKey: "fcmToken") ?? ""
        ]
        //멘토 아이디?
        if let description = detailTextView.text{
            if let token = UserDefaults.standard.string(forKey: "accessToken"){
//                APIService.shared.modifyMentorInfo(accessToken: token,
//                                                   mentoId: <#T##Int#>,
//                                                   param: parameter,
//                                                   completion: {
//                    
//                })
            }
        }
    }

}
