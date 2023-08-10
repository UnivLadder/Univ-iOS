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
        sliderView.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
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
    
    @objc func sliderChanged(slider: MultiSlider) {
//        print("thumb \(slider.draggedThumbIndex) moved")
//        print("now thumbs are at \(slider.value)") // e.g., [1.0, 4.5, 5.0]
    }
    
    @IBAction func modifyMentoDescription(_ sender: Any) {
        if let description = detailTextView.text{
            let parameter: Parameters = [
                "minPrice" : Int(sliderView.value[0]),
                "maxPrice" : Int(sliderView.value[1]),
                "description" : description
            ]
            
            if let token = UserDefaults.standard.string(forKey: "accessToken"){
                APIService.shared.modifyMentorInfo(accessToken: token,
                                                   mentoId:  UserDefaults.standard.integer(forKey: "MyMentoId"),
                                                   param: parameter,
                                                   completion: {_ in
                    
                })
            }
        }
    }

}
