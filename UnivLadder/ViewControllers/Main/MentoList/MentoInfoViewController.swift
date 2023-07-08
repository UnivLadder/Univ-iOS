//
//  MentoInfoViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/01/08.
//

import UIKit

class MentoInfoViewController: UIViewController {
    
    let starColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    let unfillstarColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    let fillStar = UIImage(systemName: "star.fill")?.withTintColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), renderingMode: .alwaysOriginal)
    let unFillStar = UIImage(systemName: "star")?.withTintColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), renderingMode: .alwaysOriginal)
    
    let mentoSubjectList = ["고등수학", "미적분", "공업수학"]
    
    //멘토 정보

    
    //Mento Info
    @IBOutlet weak var mentoNameLabel: UILabel!{
        didSet{
            mentoNameLabel.text = "홍길동"
            mentoNameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        }
    }
    
    @IBOutlet weak var mentoImg: UIImageView!{
        didSet{
            mentoImg.image = UIImage(named: "person.png")
        }
    }

    
    //star
    @IBOutlet weak var firstStar: UIImageView!{
        didSet{
            firstStar.image = fillStar
        }
    }
    
    @IBOutlet weak var secondStar: UIImageView!
    {
        didSet{
            secondStar.image = fillStar
        }
    }
    @IBOutlet weak var thirdStar: UIImageView!
    {
        didSet{
            thirdStar.image = fillStar
        }
    }
    @IBOutlet weak var fourthStar: UIImageView!
    {
        didSet{
            fourthStar.image = fillStar
        }
    }
    @IBOutlet weak var fifthStar: UIImageView!
    {
        didSet{
            fifthStar.image = unFillStar
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
            mentoClassInfoLabel.text = "홍길동의 수학 뿌시기\n고등수학부터 공업수학까지"
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
    @IBOutlet weak var mentoChatBtn: UIButton!{
        didSet{
            mentoChatBtn.setTitle("과외 문의하기", for: .normal)
            mentoChatBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    
    var score = "3"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension MentoInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mentoSubjectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MentoSubjectCell", for: indexPath) as! MentoSubjectCollectionViewCell

        cell.mentoSubjectTitle.textColor = .black
        cell.mentoSubjectTitle.text = mentoSubjectList[indexPath.row]

        return cell
        
    }
}
