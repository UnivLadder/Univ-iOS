//
//  SubjectModifyViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/03/13.
//

import UIKit
import CoreData

class SubjectModifyViewController: UIViewController {
    
    var subjectData: [SubjectModel]?
                      
    // 서치바
    @IBOutlet weak var searchBtn: UIButton!
    let searchBar = UISearchBar()
    
    // 카테고리바
    @IBOutlet weak var subjecCategoryCollectionView: UICollectionView!
    
    // 페이징
    @IBOutlet weak var pageCollectionView: UICollectionView!
    
    // 하이라이트 뷰
    @IBOutlet weak var highlightView: UIView!
    
    // Data - 과목은 서버에서 받아와
//    [ {
//      "code" : 1,
//      "topic" : "외국어",
//      "value" : "영어"
//    } ]
    
    //topic 값들
    private let subjectCategoryList = ["전체"]
    
    //value 값들
    private let subjectList: [Int: [String]] = [1 : ["전체", "교과목"],
                                                2 : ["전체", "교과목"]]
    
    
    var constraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.rightButton
        
        self.configureLayout()
        self.collectionViewLayout()
        highlightView.backgroundColor = .darkGray
        
        // local 확인
        
        //없으면 api 호출
        APIService.shared.getSubjects()
        
        //있으면 뿌려주기
        getAllSubjects()
    }
    
    
    
    fileprivate func getAllSubjects() {
        let subjects: [Subject] = CoreDataManager.shared.getSubjects()
        let topic: [String] = subjects.map({$0.topic!})

        print("subjects = \(subjects)")
        print("topics = \(topic)")
    }
    


    private func collectionViewLayout() {
        //카테고리바
        let categoryLayout = UICollectionViewFlowLayout()
        categoryLayout.itemSize = CGSize(width: 70, height: 50)
        categoryLayout.minimumLineSpacing = 10
        categoryLayout.scrollDirection = .horizontal
        subjecCategoryCollectionView.frame = .zero
        subjecCategoryCollectionView.collectionViewLayout = categoryLayout
        subjecCategoryCollectionView.decelerationRate = .fast
        subjecCategoryCollectionView.showsHorizontalScrollIndicator = false
        
        //페이징바
        let pageLayout = UICollectionViewFlowLayout()
        pageLayout.itemSize = CGSize(width: 390, height: 600)
        pageLayout.minimumLineSpacing = 0
        pageLayout.scrollDirection = .horizontal
        pageCollectionView.frame = .zero
        pageCollectionView.collectionViewLayout = pageLayout
        pageCollectionView.decelerationRate = .fast
        pageCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureLayout() {
        subjecCategoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        subjecCategoryCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        subjecCategoryCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        subjecCategoryCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        subjecCategoryCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        highlightView.translatesAutoresizingMaskIntoConstraints = false
        constraints = [
            highlightView.topAnchor.constraint(equalTo: subjecCategoryCollectionView.bottomAnchor),
            //            highlightView.bottomAnchor.constraint(equalTo: pageCollectionView.topAnchor),
            highlightView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            highlightView.heightAnchor.constraint(equalToConstant: 1),
            highlightView.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(constraints)
        
        pageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        pageCollectionView.topAnchor.constraint(equalTo: highlightView.bottomAnchor).isActive = true
        pageCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pageCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pageCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == subjecCategoryCollectionView {
            guard let cell = subjecCategoryCollectionView.cellForItem(at: indexPath) as? SubjectCategoryCollectionViewCell else { return }
            
            NSLayoutConstraint.deactivate(constraints)
            highlightView.translatesAutoresizingMaskIntoConstraints = false
            constraints = [
                highlightView.topAnchor.constraint(equalTo: subjecCategoryCollectionView.bottomAnchor),
                //                highlightView.bottomAnchor.constraint(equalTo: pageCollectionView.topAnchor),
                highlightView.heightAnchor.constraint(equalToConstant: 1),
                highlightView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                highlightView.trailingAnchor.constraint(equalTo: cell.trailingAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == subjecCategoryCollectionView{
            return subjectCategoryList.count
        }else{
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == subjecCategoryCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCategoryCell", for: indexPath) as! SubjectCategoryCollectionViewCell
            cell.backgroundColor = .white
            cell.subjectCategoryTitleLabel.text = subjectCategoryList[indexPath.row]
            
            //            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCollectionViewCell.identifier, for: indexPath) as? TabCollectionViewCell else { return UICollectionViewCell() }
            //            cell.configureCell(tapName[indexPath.item])
            
            return cell
        } else if collectionView == pageCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath) as? PageCollectionViewCell else { return UICollectionViewCell() }
            
//            cell.subjectTitle.text = subjectList[indexPath.row]
            //            cell.configureCell(color: pageBackgroundColor[indexPath.item])
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}


extension SubjectModifyViewController {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //        guard let layout = self.pageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        //        if scrollView == pageCollectionView {
        //            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        //            let offset = targetContentOffset.pointee
        //            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        //            let roundedIndex = round(index)
        //            let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
        //
        //            targetContentOffset.pointee = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left,
        //                                                  y: scrollView.contentInset.top)
        //
        //            // topTapItem Select
        //            tapBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
        //            // collectionView didSelectedItemAt delegate
        //            collectionView(tapBarCollectionView, didSelectItemAt: indexPath)
        //            // topTapMenu Scroll
        //            tapBarCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        //        }
    }
    
}
