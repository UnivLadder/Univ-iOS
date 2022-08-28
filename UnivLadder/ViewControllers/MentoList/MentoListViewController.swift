//
//  MentoListViewController.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/12/06.
//

import UIKit

class MentoListViewController: UIViewController {
    let mainView = MainView()
    //    let mentoListView = MontoListView()
    //    private lazy var mainView = MainView.init(frame: self.view.frame)
    var subjectList = ["교과목", "수시/논술", "입시/경시대회", "외국어" ,"외국어 시험", "미술", "음악", "악기", "국악", "댄스", "IT/컴퓨터", "디자인", "취업 준비", "스포츠", "패션/뷰티", "사진/영상", "연기/공연/영화", "요리/커피"]
    var imgList = ["교과목.png", "외국어.png", "미술.png"]
    
    var mentoList = ["안이연", "안이연", "안이연", "안이연", "안이연", "안이연", "안이연"]
    
    static func instance() -> MentoListViewController {
        return MentoListViewController.init(nibName: nil, bundle: nil)
    }
    
    
    override func loadView() {
        view = mainView
        setupCollectionView()
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
        
    }
    
}

extension MentoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.subjectCollectionView {
            return subjectList.count
        }else{
            return mentoList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
        //subject list
        if collectionView == mainView.subjectCollectionView {
            let subjectCellText = subjectList[indexPath.item]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubjectListCell.subjectRegisterId, for: indexPath) as UICollectionViewCell
                    as? SubjectListCell else {
                return UICollectionViewCell()
            }
            cell.label.text = subjectCellText
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
