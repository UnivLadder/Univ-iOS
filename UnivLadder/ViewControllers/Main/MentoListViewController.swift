//
//  MentoListViewController.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/12/06.
//

import UIKit

//
class MentoListViewController: UIViewController {
    
    let mainView = MainView()
    var categoryArr = [String]()

    // 지금 뜨고 있는 멘토 data
    var mentoList = [["안이연","person.png"], ["박강현","펭수.png"],["충주","person.png"],["오스틴","펭수.png"],["림팍","펭수.png"]]
    static func instance() -> MentoListViewController {
        return MentoListViewController.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - UI func
    override func loadView() {
//        APIService.shared.getSubjects()
        view = mainView
        dataParsing()
        setupCollectionView()
    }
    
    // UI component 호출
    func dataParsing(){
        let subjects = UserDefaultsManager.subjectList
        var categorySet = Set<String>()
        for i in 0..<subjects!.count{
            categorySet.insert(subjects.map{$0[i].topic}!
            )
        }
        categoryArr = Array(categorySet)
    }
    
    // array 중복 제거
    func removeDuplicate (_ array: [String]) -> [String] {
        var removedArray = [String]()
        for i in array {
            if removedArray.contains(i) == false {
                removedArray.append(i)
            }
        }
        return removedArray
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
    
    @objc
    func setBtnTap() {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "MentoCategory")
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    /// 카테고리명별 이미지 조건처리
    /// - Parameter categoryName: 카테고리명
    /// - Returns: 카테고리 이미지 파일명
    func categoryImgSetting(categoryName: String) -> String {
        switch categoryName{
        case "외국어" :
            return "외국어_3x.png"
        case "입시/경시대회", "취업준비":
            return "취업준비_3x.png"
        case "교과목", "패션":
            return "패션_뷰티_3x.png"
        case "수시/논술", "시험":
            return "시험_자격증_3x.png"
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
            cell.label.text = mentoList[indexPath.row][0]
            
            let customImage = UIImage(named: mentoList[indexPath.row][1])
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
        if collectionView == mainView.categoryCollectionView {
            return 20
        }
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainView.categoryCollectionView {
            let CategoryMentoListVC = self.storyboard?.instantiateViewController(withIdentifier: "MentoInfoViewController")
            self.navigationController?.pushViewController(CategoryMentoListVC!, animated: true)
        }else{
            print("멘토 선택")
        }
    }
}
