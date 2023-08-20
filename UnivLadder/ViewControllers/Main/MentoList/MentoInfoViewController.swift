//
//  MentoInfoViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/01/08.
//

import UIKit
import Cosmos

class MentoInfoViewController: UIViewController {
    
    var mentoSubjectList = [RecommendMentor.Subject]()
    
    //멘토 정보
    var mentoInfo: RecommendMentor?
    
    @IBOutlet weak var ratingView: CosmosView!{
        didSet{
            if let info = mentoInfo{
                if let rating = info.averageReviewScore{
                    ratingView.rating = rating
                }else{
                    ratingView.rating = 0.0
                }
            }
        }
    }
    
    @IBOutlet weak var ratingView2: CosmosView!{
        didSet{
            if let info = mentoInfo{
                if let rating = info.averageReviewScore{
                    ratingView2.rating = rating
                }else{
                    ratingView2.rating = 0.0
                }
            }
        }
    }
    @IBOutlet weak var ratingCountLabel: UILabel!{
        didSet{
            if let info = mentoInfo{
                if let rating = info.averageReviewScore{
                    ratingCountLabel.text = "(\(rating))"
                }else{
                    ratingCountLabel.text = "(0.0)"
                }
            }
        }
    }
    
    @IBOutlet weak var verifyStackView: UIStackView!{
        didSet{
            verifyStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var emailStackView: UIStackView!{
        didSet{
            emailStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var educationStackView: UIStackView!{
        didSet{
            educationStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    
    //Mento Info
    @IBOutlet weak var mentoNameLabel: UILabel!{
        didSet{
            mentoNameLabel.text = mentoInfo?.account.name
            mentoNameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        }
    }
    
    @IBOutlet weak var mentoImg: UIImageView!{
        didSet{
            if let img = mentoInfo?.account.thumbnail{
                mentoImg.image = UIImage(named: img)
            }else{
                mentoImg.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.lightGray)
            }
        }
    }
    
    //멘토 정보 label
    @IBOutlet weak var mentoInfoTitleLabel: UILabel!{
        didSet{
            mentoInfoTitleLabel.text = "멘토 정보"
            mentoInfoTitleLabel.font = UIFont.boldSystemFont(ofSize: Constant.menuFontSizeXS)
        }
    }
    
    //본인인증여부
    @IBOutlet weak var verifyLabel: UILabel!{
        didSet{
            verifyLabel.text = "본인 인증 완료"
        }
    }
    
    @IBOutlet weak var mentoEmailLabel: UILabel!{
        didSet{
            mentoEmailLabel.text = "lxxeyeon@gmail.com"
        }
    }
    
    
    //학력
    @IBOutlet weak var montoUnivInfoLabel: UILabel!{
        didSet{
            montoUnivInfoLabel.text = "서울대학교 컴퓨터공학과"
        }
    }
    
    //수업 정보 label
    @IBOutlet weak var mentoClassInfoTitleLabel: UILabel!{
        didSet{
            mentoClassInfoTitleLabel.text = "수업 상세설명"
            mentoClassInfoTitleLabel.font = UIFont.boldSystemFont(ofSize: Constant.menuFontSizeXS)
        }
    }
    
    @IBOutlet weak var mentoClassInfoLabel: UILabel!{
        didSet{
            if let description = mentoInfo?.description{
                if description.count > 0 {
                    mentoClassInfoLabel.text = description
                }else{
                    mentoClassInfoLabel.text = "수업 상세 설명이 없습니다."
                }
            }else{
                mentoClassInfoLabel.text = "수업 상세 설명이 없습니다."
            }
            mentoClassInfoLabel.numberOfLines = 5
        }
    }
    
    @IBOutlet weak var mentoSubjectTitleInfo: UILabel!{
        didSet{
            mentoSubjectTitleInfo.text = "제공 서비스"
            mentoSubjectTitleInfo.font = UIFont.boldSystemFont(ofSize: Constant.menuFontSizeXS)
        }
    }
    
    @IBOutlet weak var mentoSubjectCollectionView: UICollectionView!
    
    //채팅방 넘어가는 버튼
    @IBOutlet weak var mentoChatBtn: UIButton!
    // 멘토 메시지 전송
    @IBAction func mentoChatAction(_ sender: Any) {
        let ChatRoomStoryboard = UIStoryboard.init(name: "Chatting", bundle: nil)
        guard let ChatRoomVC = ChatRoomStoryboard.instantiateViewController(withIdentifier: "ChatRoomViewController") as? ChatRoomViewController
        else { return }
        self.navigationController?.pushViewController(ChatRoomVC, animated: true)
        // 받는 사람 : 멘토 아이디? 멘토 accountid
//        ChatRoomVC.mentoUser = mentoInfo
    }
    
    @IBOutlet weak var reviewTitle: UILabel!{
        didSet{
            reviewTitle.text = "리뷰"
            reviewTitle.font = UIFont.boldSystemFont(ofSize: Constant.menuFontSizeXS)
        }
    }
    
    @IBOutlet weak var registerReviewBtn: UIButton!{
        didSet{
            registerReviewBtn.setTitle("리뷰 등록", for: .normal)
            registerReviewBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        }
    }
    
    @IBOutlet weak var totalReviewScoreLabel: UILabel!{
        didSet{
            totalReviewScoreLabel.font = UIFont.boldSystemFont(ofSize: 50)
            if let score = mentoInfo?.averageReviewScore{
                totalReviewScoreLabel.text = "\(score)"
            }else{
                totalReviewScoreLabel.text = "0.0"
            }
        }
    }
    
    @IBOutlet weak var reviewCountLabel: UILabel!{
        didSet{
            reviewCountLabel.font = UIFont.boldSystemFont(ofSize: 13)
            if let reviewCount = mentoInfo?.reviewCount{
                reviewCountLabel.text = "총 \(reviewCount)개의 리뷰"
            }else{
                reviewCountLabel.text = "총 0개의 리뷰"
            }
        }
    }
    
    @IBAction func goToRegisterView(_ sender: Any) {
        if let ReviewMentoVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistReviewViewController") as? RegistReviewViewController{
            self.navigationController?.pushViewController(ReviewMentoVC, animated: true)
            ReviewMentoVC.mentoId = mentoInfo?.mentoId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "멘토 정보"
        setUpUI()
    }
    
    func setUpUI() {
        mentoChatBtn.layer.cornerRadius = 10
        mentoChatBtn.tintColor = UIColor.white
        mentoChatBtn.setTitle(NSLocalizedString("mentoChatStart", comment: ""), for: .normal)
        mentoChatBtn.titleLabel?.font = Fonts.EsamanruOTF.medium.font(size: 20)
        guard let mentoInfo = mentoInfo else { return }
        if let minPrice = mentoInfo.minPrice, let maxPrice = mentoInfo.maxPrice  {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            priceLabel.text = "\(String(describing: numberFormatter.string(from: NSNumber(value: minPrice))!))원 ~ \(String(describing: numberFormatter.string(from: NSNumber(value: maxPrice))!))원"
        }else{
            priceStackView.isHidden = true
        }
        
        if let subject = mentoInfo.listOfExtracurricularSubjectData{
            for list in subject {
                mentoSubjectList.append(list)
                
            }
        }
    }
}

// 제공 서비스 : 멘토 과목 리스트
extension MentoInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MentoSubjectCell", for: indexPath) as! MentoSubjectCollectionViewCell
        cell.mentoSubjectTitle.sizeToFit()
        let cellWidth = cell.mentoSubjectTitle.frame.width + 10
        return CGSize(width: cellWidth, height: 10)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mentoSubjectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MentoSubjectCell", for: indexPath) as! MentoSubjectCollectionViewCell
        cell.mentoSubjectTitle.textColor = .black
        cell.mentoSubjectTitle.text = mentoSubjectList[indexPath.row].value
        return cell
    }
}
