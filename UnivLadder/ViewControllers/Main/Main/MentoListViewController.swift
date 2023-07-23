//
//  MentoListViewController.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/12/06.
//

import UIKit
import Alamofire
class MentoListViewController: UIViewController {
    
    let mainView = MainView()
    var categoryArr = [String]()
    // 지금 뜨고 있는 멘토
    var recommendMentoArr = [RecommendMentor]()
    
    let categoryList = UserDefaultsManager.categoryList
    // 지금 뜨고 있는 멘토 data
    //id, thumbnail, name
    var mentoList = [[100, 10, "w4.jpg", "이정은"], [200, 11, nil, "박강현"]]
    var customImage: UIImage?
    static func instance() -> MentoListViewController {
        return MentoListViewController.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - UI func
    override func loadView() {
        view = mainView
        dataParsing()
        setupCollectionView()
    }
    
    /// 카테고리, 추천 멘토 데이터 파싱
    func dataParsing(){
        let parameter: Parameters = [
            "fcmToken" : UserDefaults.standard.string(forKey: "fcmToken") ?? ""
        ]
        APIService.shared.putFCMToken(param: parameter)
        //카테고리
        let subjects = UserDefaultsManager.subjectList
        var tmpArr: [String] = []
        for i in 0..<subjects!.count{
            tmpArr.append(subjects.map{$0[i].topic}!)
        }
        categoryArr = NSOrderedSet(array: tmpArr).map({ $0 as! String })
        UserDefaultsManager.categoryList = categoryArr
        
        // 추천 멘토
        if let serverrecommnedMentorList = UserDefaultsManager.recommendMentorList{
            recommendMentoArr = serverrecommnedMentorList
        }
        
        recommendMentoArr.enumerated().forEach({
            mentoList.append([$0.element.mentoId, $0.element.id, $0.element.thumbnail, $0.element.name])
        })
    }
    
    private func setupCollectionView() {
        mainView.mentoCollectionView.delegate = self
        mainView.mentoCollectionView.dataSource = self
        //한 화면에 collectionview를 2개 사용하기 위해 register 사용
        mainView.mentoCollectionView.register(MentoListCell.self, forCellWithReuseIdentifier: MentoListCell.mentoRegisterId)
        
        mainView.categoryCollectionView.delegate = self
        mainView.categoryCollectionView.dataSource = self
        mainView.categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.categoryRegisterId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.searchMentoButton.addTarget(self, action: #selector(setBtnTap), for: .touchUpInside)
        mainView.searchMentoButton.addTarget(self, action: #selector(setBtnTap), for: .touchUpInside)
    }
    
    // 카테고리 리스트뷰로 이동
    // VC : CategoryListViewController
    // segue identity : CategorySegue
    @objc
    func setBtnTap() {
        self.performSegue(withIdentifier: "CategorySegue", sender: nil)
    }
    
    /// 카테고리명별 이미지 조건처리
    /// - Parameter categoryName: 카테고리명
    /// - Returns: 카테고리 이미지 파일명
    func categoryImgSetting(categoryName: String) -> String {
        var findCategry = categoryName

        if let findIdx: String.Index = categoryName.firstIndex(of: "/"){
            findCategry = String(categoryName[..<findIdx])
        }
        
        switch findCategry{
        case "미술" :
            return "미술_3x.png"
        case "사진" :
            return "사진_영상_연기_3x.png"
        case "스포츠" :
            return "스포츠_건강_3x.png"
        case "시험" :
            return "시험_자격증_3x.png"
        case "실무교육" :
            return "실무교육_디자인_3x.png"
        case "악기" :
            return "악기_3x.png"
        case "외국어" :
            return "외국어_3x.png"
        case "외국어시험" :
            return "외국어시험_3x.png"
        case "음악이론" :
            return "음악이론_보컬_3x.png"
        case "취업준비" :
            return "취업준비_3x.png"
        case "투자" :
            return "투자_부업_N잡_3x.png"
        case "패션":
            return "패션_뷰티_3x.png"
        default:
            return "학업_3x.png"
        }
    }
}

extension MentoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.categoryCollectionView {
            return categoryArr.count
        }else{
            return mentoList.count
            //            return recommendMentoArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //subject list
        if collectionView == mainView.categoryCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.categoryRegisterId, for: indexPath) as? CategoryCell else {
                return UICollectionViewCell()
            }
            
            cell.label.text = categoryArr[indexPath.row]
            let customImage = UIImage(named: categoryImgSetting(categoryName: categoryArr[indexPath.row]))
            let newImageRect = CGRect(x: 0, y: 0, width: Constant.categoryImgSize, height: Constant.categoryImgSize)
            UIGraphicsBeginImageContext(CGSize(width: Constant.categoryImgSize, height: Constant.categoryImgSize))
            customImage?.draw(in: newImageRect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
            UIGraphicsEndImageContext()
            
            cell.imageView.image = newImage
            cell.imageView.layer.cornerRadius = 10
            cell.imageView.clipsToBounds = true
            
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MentoListCell.mentoRegisterId, for: indexPath) as? MentoListCell else {
                return UICollectionViewCell()
            }
            //UI용
            //[100, 10, "w4.jpg", "이정은"]
            cell.label.text = mentoList[indexPath.row][3] as? String
            
            if let mentoImg = mentoList[indexPath.row][2] {
                customImage =  UIImage(named: (mentoImg as? String)!)
            }else{
                customImage = UIImage(systemName: "person.crop.circle.fill")
            }
            
            //실데이터
            //cell.label.text = recommendMentoArr[indexPath.row].name
            //            let customImage = (recommendMentoArr[indexPath.row].thumbnail == nil) ? UIImage(systemName: "person.crop.circle.fill") : UIImage(named: mentoList[indexPath.row][1])
            let newImageRect = CGRect(x: 0, y: 0, width: Constant.profileImgSize, height: Constant.profileImgSize)
            UIGraphicsBeginImageContext(CGSize(width: Constant.profileImgSize, height: Constant.profileImgSize))
            customImage?.draw(in: newImageRect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
            UIGraphicsEndImageContext()
            
            cell.tvImageView.image = newImage
            cell.tvImageView.layer.cornerRadius = CGFloat(Constant.profileImgSize/2)
            cell.tvImageView.clipsToBounds = true
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainView.categoryCollectionView {
            return CGSize.init(width: Constant.categoryImgSize, height: Constant.categoryImgSize)
        }else{
            return CGSize.init(width: Constant.profileImgSize, height: 120)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 카테고리 셀 간격
        if collectionView == mainView.categoryCollectionView {
            return 20
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainView.categoryCollectionView {
            let CategoryMentoListVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryMentoList") as? CategoryMentoListViewController
            self.navigationController?.pushViewController(CategoryMentoListVC!, animated: true)
            if let categoryList = categoryList?[indexPath.row] {
                CategoryMentoListVC!.category = categoryList
            }
        }else{
            let params = ["accountId" : 2,
                          "message" : "민지차",
                          "type" : "TEXT"] as [String : Any]
            
            APIService.shared.sendDirectMessage(param: params)
            // 추천 아이디 "id" : 1,
            // 해당 멘토 페이지 이동
            // 추천멘토 클릭
            //            var mentoId = mentoList[indexPath.row][0]
            //            APIService.shared.getMentorInfo(mentoId: mentoId as! Int, completion:{ _ in
            //                
            //            })
            //            
            //            APIService.shared.getMentorSubjects(mentoId: mentoId as! Int, completion: { _ in
            //                
            //                let MentoListVC = self.storyboard?.instantiateViewController(withIdentifier: "MentoInfoViewController")
            //                
            //                self.navigationController?.pushViewController(MentoListVC!, animated: true)
            //            })
            
        }
    }
}
