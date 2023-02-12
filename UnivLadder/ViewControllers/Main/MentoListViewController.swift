//
//  MentoListViewController.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/12/06.
//

import UIKit

class MentoListViewController: UIViewController {
    let mainView = MainView()
    
    // 멘토 찾기
    
    // 과목 카테고리 이름
    var categoryList: [String] = []
    // 추후 이미지 더 추가하기
    var imgList = ["교과목.png", "외국어.png", "미술.png","교과목.png","외국어.png","미술.png"]
    
    // 지금 뜨고 있는 멘토
    var mentoList = ["안이연", "안이연", "안이연", "안이연", "안이연", "안이연", "안이연"]
    
    static func instance() -> MentoListViewController {
        return MentoListViewController.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - UI func
    override func loadView() {
        view = mainView
        dataParsing()
        setupCollectionView()
    }
    
    //UI component 호출
    func dataParsing(){
        // user 프로필 데이터
        //coredata userinfo 매칭

        
        
        //로그인 이후 한번만 실행
//        APIService.shared.getSubjects()
        // 멘터 찾기 데이터
        let subjects: [SubjectEntity] = CoreDataManager.shared.getSubjectEntity()
        let topics: [String] = subjects.map({$0.topic!})
        categoryList = removeDuplicate(topics)
        
        //지금 뜨고 있는 멘토 데이터
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
        mainView.subjectCollectionView.delegate = self
        mainView.subjectCollectionView.dataSource = self
        mainView.subjectCollectionView.register(SubjectListCell.self, forCellWithReuseIdentifier: SubjectListCell.subjectRegisterId)
        
        mainView.mentoCollectionView.delegate = self
        mainView.mentoCollectionView.dataSource = self
        mainView.mentoCollectionView.register(MentoListCell.self, forCellWithReuseIdentifier: MentoListCell.mentoRegisterId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.searchMentoButton.addTarget(self, action: #selector(setBtnTap), for: .touchUpInside)
    }
    
    @objc
    func setBtnTap() {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "MentoCategory")
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
}

extension MentoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.subjectCollectionView {
            return categoryList.count
        }else{
            return mentoList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //subject list
        if collectionView == mainView.subjectCollectionView {
            let subjectCellText = categoryList[indexPath.item]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubjectListCell.subjectRegisterId, for: indexPath) as UICollectionViewCell
                    as? SubjectListCell else {
                return UICollectionViewCell()
            }
            cell.label.text = subjectCellText
            cell.imageView.image = UIImage(named: imgList[indexPath.item])
            
            return cell
            
            //mento list
            //        }else if collectionView == mainView.collectionView2 {
        }else{
            let cellText = mentoList[indexPath.count]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MentoListCell.mentoRegisterId, for: indexPath) as? MentoListCell else {
                return UICollectionViewCell()
            }
            cell.label.text = cellText
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainView.subjectCollectionView {
            return CGSize.init(width: 100, height: 100)
        }else{
            return CGSize.init(width: 80, height: 100)
        }
        
    }
        
   
}
