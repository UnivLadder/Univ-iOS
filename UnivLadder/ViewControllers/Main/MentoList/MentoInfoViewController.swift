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
            mentoNameLabel.font = Fonts.EsamanruOTF.medium.font(size: 23)
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
            mentoInfoTitleLabel.font = Fonts.EsamanruOTF.medium.font(size: Constant.menuFontSizeXS)
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
            mentoClassInfoTitleLabel.font = Fonts.EsamanruOTF.medium.font(size: Constant.menuFontSizeXS)
        }
    }
    
    @IBOutlet weak var mentoClassInfoLabel: UILabel!{
        didSet{
            mentoClassInfoLabel.text = "수업 상세 설명이 없습니다."
            if let description = mentoInfo?.description{
                if description.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    mentoClassInfoLabel.text = "수업 상세 설명이 없습니다."
                }else{
                    mentoClassInfoLabel.text = description
                }
            }
            mentoClassInfoLabel.numberOfLines = 5
        }
    }
    
    @IBOutlet weak var mentoSubjectTitleInfo: UILabel!{
        didSet{
            mentoSubjectTitleInfo.text = "제공 서비스"
            mentoSubjectTitleInfo.font = Fonts.EsamanruOTF.medium.font(size: Constant.menuFontSizeXS)
        }
    }
    
    @IBOutlet weak var mentoSubjectCollectionView: UICollectionView!
    
    //채팅방 넘어가는 버튼
    @IBOutlet weak var mentoChatBtn: UIButton!
    // 멘토 메시지 전송
    @IBAction func mentoChatAction(_ sender: Any) {
        if let mento = mentoInfo {
            APIService.shared.getDirectMessages(myaccessToken: UserDefaults.standard.string(forKey: "accessToken")!, senderAccountId: mento.account.id, completion: { res in
                let ChatRoomStoryboard = UIStoryboard.init(name: "Chatting", bundle: nil)
                guard let ChatRoomVC = ChatRoomStoryboard.instantiateViewController(withIdentifier: "ChatRoomViewController") as? ChatRoomViewController
                else { return }
                ChatRoomVC.allChatting = res
                ChatRoomVC.userName = mento.account.name
                ChatRoomVC.userAccount = mento.account.id
                self.navigationController?.pushViewController(ChatRoomVC, animated: true)
            })
        }
    }
    
    @IBOutlet weak var reviewTitle: UILabel!{
        didSet{
            reviewTitle.text = "리뷰"
            reviewTitle.font = Fonts.EsamanruOTF.medium.font(size: Constant.menuFontSizeXS)
        }
    }

    @IBOutlet weak var registerReviewBtn: UIButton!{
        didSet{
            registerReviewBtn.setTitle("리뷰 등록", for: .normal)
            registerReviewBtn.titleLabel?.font = Fonts.EsamanruOTF.medium.font(size: 17)
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
        configure()
        setUpUI()
//        mentoSubjectCollectionView.heightAnchor.constraint(equalToConstant: mentoSubjectCollectionView.collectionViewLayout.collectionViewContentSize.height).isActive = true
    }
    
    func configure() {
        mentoSubjectCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()

        if let flowLayout = mentoSubjectCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            
            mentoSubjectCollectionView.translatesAutoresizingMaskIntoConstraints = false
            mentoSubjectCollectionView.isScrollEnabled = false
        }
        mentoSubjectCollectionView.delegate = self
        mentoSubjectCollectionView.dataSource = self
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

class CollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 10
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 10.0
        self.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}

// 제공 서비스 : 멘토 과목 리스트
extension MentoInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MentoSubjectCell", for: indexPath) as! MentoSubjectCollectionViewCell
    //        cell.mentoSubjectTitle.sizeToFit()
    //        let cellWidth = cell.mentoSubjectTitle.frame.width + 10
    //        return CGSize(width: cellWidth, height: 10)
    //    }
    
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
