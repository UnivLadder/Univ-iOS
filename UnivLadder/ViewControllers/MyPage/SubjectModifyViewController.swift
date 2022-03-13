//
//  SubjectModifyViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/03/13.
//

import UIKit

class SubjectModifyViewController: UIViewController {

    @IBOutlet weak var searchBtn: UIButton!
    let searchBar = UISearchBar()
    
    @IBOutlet weak var subjecCategoryCollectionView: UICollectionView!

    @IBOutlet weak var subjectModifyCollectionView: UICollectionView!
    
    
    var subjecCategoryList = ["전체","교과목", "수시/논술", "입시/경시대회", "외국어" ,"외국어 시험", "미술", "음악", "악기", "국악", "댄스", "IT/컴퓨터", "디자인", "취업 준비", "스포츠", "패션/뷰티", "사진/영상", "연기/공연/영화", "요리/커피"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.rightButton

    }

    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(buttonPressed(_:)))
            button.tag = 1
        return button
    }()

    //searchbar로 바뀌었을때 높이 바뀌는거 수정 필요 + 버튼 사라지게?
    @objc private func buttonPressed(_ sender: Any) {
        if let button = sender as? UIBarButtonItem {
            switch button.tag {
            case 1:
                self.navigationItem.titleView = searchBar
            default:
                print("error")
            }
        }
    }
}
extension SubjectModifyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == subjecCategoryCollectionView{
            return subjecCategoryList.count
        }else{
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCategoryCell", for: indexPath) as! SubjectCategoryCollectionViewCell
        cell.backgroundColor = .white
        cell.subjectCategoryTitleLabel.text = subjecCategoryList[indexPath.row]
        
        //사용자의 기존 선택한 과목 보여주기
//        if {
//            cell.isSelected = true
//        }
        
        return cell
    }
    
}
