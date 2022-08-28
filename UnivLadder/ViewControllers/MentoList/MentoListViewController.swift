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
    
    static func instance() -> MentoListViewController {
        return MentoListViewController.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = mainView
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(SubjectListCell.self, forCellWithReuseIdentifier: SubjectListCell.registerId)
        mainView.collectionView2.register(MentoListCell.self, forCellWithReuseIdentifier: MentoListCell.registerId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension MentoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionView {

        }else{
            
        }
        
        
        let cellText = subjectList[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubjectListCell.registerId, for: indexPath) as? SubjectListCell else {
            return UICollectionViewCell()
        }
        cell.label.text = cellText

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 100)
    }
    
}
