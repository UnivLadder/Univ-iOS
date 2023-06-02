//
//  SubjectModifyViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/03/13.
//

import UIKit
import CoreData


//다음에 할거
// cell width 유동적으로
// paging cell custom

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
    private var subjectCategoryList = ["전체"]
    
    //value 값들
    lazy var subjectList: [String: String] = [subjectCategoryList[0] : "국어"]
    
    var constraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.rightButton
        
        // local 데이터 확인 로직 추가
        
        //없으면 api 호출
//        APIService.shared.getSubjects()
        //있으면 뿌려주기
        
        
        getAllSubjects()
        self.configureLayout()
        self.collectionViewLayout()


    }
    
    fileprivate func getAllSubjects() {
        let subjects: [SubjectEntity] = CoreDataManager.shared.getSubjectEntity()
        // 중복 topic 제거
        subjectCategoryList.append(contentsOf: removeDuplicate(subjects.map({$0.topic!})))
        
        for index in 0..<subjectCategoryList.count{
            print("\(index) : \(subjectCategoryList[index])")
            var key = subjectCategoryList[index]
            subjectList[key] = subjects.map({$0.value!})[index]
        }
        
        print(subjectList)
        
        //        dict["key"] = "value"
        
        //
        //        print("subjects = \(subjects)")
        //        print("topics = \(subjectCategoryList)")
    }
    
    private func collectionViewLayout() {
        //카테고리바
        let categoryLayout = UICollectionViewFlowLayout()
        categoryLayout.itemSize = CGSize(width: 80, height: 50)
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
        highlightView.backgroundColor = #colorLiteral(red: 0.359387219, green: 0.1173390374, blue: 0.6395683885, alpha: 1)
        
        constraints = [
            highlightView.topAnchor.constraint(equalTo: subjecCategoryCollectionView.bottomAnchor),
            highlightView.bottomAnchor.constraint(equalTo: pageCollectionView.topAnchor),
            highlightView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            highlightView.heightAnchor.constraint(equalToConstant: 3),
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
    
    func removeDuplicate (_ array: [String]) -> [String] {
        var removedArray = [String]()
        for i in array {
            if removedArray.contains(i) == false {
                removedArray.append(i)
            }
        }
        return removedArray
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
                highlightView.bottomAnchor.constraint(equalTo: pageCollectionView.topAnchor),
                highlightView.heightAnchor.constraint(equalToConstant: 3),
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
        // 대주제(topic) cell view
        if collectionView == subjecCategoryCollectionView{
            return subjectCategoryList.count
            // 교과목(value) cell view
        }else if collectionView == pageCollectionView {
            return 10
        }else{
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 대주제(topic) cell view
        if collectionView == subjecCategoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCategoryCell", for: indexPath) as! SubjectCategoryCollectionViewCell
            cell.backgroundColor = .white
            
//            cell.isSelected = false
            if indexPath.row == 0 {
                cell.isSelected = true
            }
      
            cell.subjectCategoryTitleLabel.textColor = .lightGray
            cell.subjectCategoryTitleLabel.text = subjectCategoryList[indexPath.row]
            return cell
            
            // 교과목(value) cell view
        } else if collectionView == pageCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath) as? PageCollectionViewCell else { return UICollectionViewCell() }
            lazy var backColor: [UIColor] = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 1, green: 0.8492714985, blue: 0.8835704761, alpha: 1), #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)]

            cell.subjectTitle.text = "영어"
            // indexPath 에러처리 로직 추가하기
            cell.backgroundColor = backColor[indexPath.row]
            //            cell.subjectTitle.text = subjectList[indexPath.row]
            //            cell.configureCell(color: pageBackgroundColor[indexPath.item])
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}


extension SubjectModifyViewController {
    // 스크롤 부드럽게
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.pageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        if scrollView == pageCollectionView {
            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
            let offset = targetContentOffset.pointee
            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
            let roundedIndex = round(index)
            let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
            
            targetContentOffset.pointee = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left,
                                                  y: scrollView.contentInset.top)
            
            // topTapItem Select
            subjecCategoryCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
            // collectionView didSelectedItemAt delegate
            collectionView(subjecCategoryCollectionView, didSelectItemAt: indexPath)
            // topTapMenu Scroll
            subjecCategoryCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
}
