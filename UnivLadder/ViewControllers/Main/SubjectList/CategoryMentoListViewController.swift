//
//  CategoryMentoListViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/01/08.
//

import UIKit

//카테고리별 멘토리스트 화면
class CategoryMentoListViewController: UIViewController {
    // 카테고리바
    @IBOutlet weak var subjecInCategoryCollectionView: UICollectionView!
    
    // 페이징
    @IBOutlet weak var pageTableView: UITableView!
    
    // 하이라이트 뷰
    @IBOutlet weak var highlightView: UIView!
    
    //클릭한 카테고리에 해당하는 과목들
    public var category: String?
    
    private var subjectCategoryList:[String] = []
    let categoryList = UserDefaultsManager.categoryList
    var subjectDictionary: [String:[String]] = [:]
    let userSubjectHash = UserDefaultsManager.subjectHash ?? Dictionary<Int,[Int]>()
    var constraints: [NSLayoutConstraint] = []
    override func viewDidLoad() {
        if let category = category{
            if let subjectDictionary = UserDefaultsManager.subjectDictionary{
                subjectCategoryList = subjectDictionary[category]!
            }
        }
        super.viewDidLoad()
        self.configureLayout()
        self.collectionViewLayout()
        self.navigationItem.title = category

    }
    
    private func collectionViewLayout() {

        //카테고리바
        let categoryLayout = UICollectionViewFlowLayout()
        
        categoryLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        //        categoryLayout.itemSize = CGSize(width: 80, height: 50)
        //        categoryLayout.minimumLineSpacing = 10
        categoryLayout.scrollDirection = .horizontal
        subjecInCategoryCollectionView.frame = .zero
        subjecInCategoryCollectionView.collectionViewLayout = categoryLayout
        subjecInCategoryCollectionView.decelerationRate = .fast
        subjecInCategoryCollectionView.showsHorizontalScrollIndicator = false
        //
        //페이징바
        let pageLayout = UICollectionViewFlowLayout()
        pageLayout.itemSize = CGSize(width: 390, height: 600)
        pageLayout.minimumLineSpacing = 0
        pageLayout.scrollDirection = .horizontal
        pageTableView.frame = .zero
        //        pageTableView.collectionViewLayout = pageLayout
        pageTableView.decelerationRate = .fast
        pageTableView.showsHorizontalScrollIndicator = false
    }
    
    private func configureLayout() {
        //        subjecInCategoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        subjecInCategoryCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        subjecInCategoryCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        subjecInCategoryCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        subjecInCategoryCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        highlightView.translatesAutoresizingMaskIntoConstraints = false
        highlightView.backgroundColor = #colorLiteral(red: 0.4269999862, green: 0.4297476812, blue: 0.90200001, alpha: 1)
        
        constraints = [
            highlightView.topAnchor.constraint(equalTo: subjecInCategoryCollectionView.bottomAnchor),
            highlightView.bottomAnchor.constraint(equalTo: pageTableView.topAnchor),
            highlightView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            highlightView.heightAnchor.constraint(equalToConstant: 3),
            highlightView.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(constraints)
        
        pageTableView.translatesAutoresizingMaskIntoConstraints = false
        pageTableView.topAnchor.constraint(equalTo: highlightView.bottomAnchor).isActive = true
        pageTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pageTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pageTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension CategoryMentoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 카테고리 선택시 tableview reload
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        pageTableView.reloadData()
        
        if collectionView == subjecInCategoryCollectionView{
            if let cell = collectionView.cellForItem(at: indexPath) as? SubjectInCategoryCollectionViewCell{
                cell.subjectTitleLabel.textColor = .lightGray
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == subjecInCategoryCollectionView {
            guard let cell = subjecInCategoryCollectionView.cellForItem(at: indexPath) as? SubjectInCategoryCollectionViewCell else { return }
            
            cell.subjectTitleLabel.textColor = .black
            NSLayoutConstraint.deactivate(constraints)
            highlightView.translatesAutoresizingMaskIntoConstraints = false
            constraints = [
                highlightView.topAnchor.constraint(equalTo: subjecInCategoryCollectionView.bottomAnchor),
                highlightView.bottomAnchor.constraint(equalTo: pageTableView.topAnchor),
                highlightView.heightAnchor.constraint(equalToConstant: 3),
                highlightView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                highlightView.trailingAnchor.constraint(equalTo: cell.trailingAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            //            pageTableView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 대주제(topic) cell view
        if collectionView == subjecInCategoryCollectionView{
            return subjectCategoryList.count
            // 교과목(value) cell view
        }else{
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == subjecInCategoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectInCategoryCell", for: indexPath) as! SubjectInCategoryCollectionViewCell
            
            cell.subjectTitleLabel.sizeToFit()
            let cellWidth = cell.subjectTitleLabel.frame.width + 20
            return CGSize(width: 80, height: 30)
            
        } else {
            return CGSize()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 대주제(topic) cell view
        if collectionView == subjecInCategoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectInCategoryCell", for: indexPath) as! SubjectInCategoryCollectionViewCell
            cell.subjectTitleLabel.textColor = .lightGray
            cell.subjectTitleLabel.text = subjectCategoryList[indexPath.row]
            if indexPath.row == 0 {
                collectionView.selectItem(at: indexPath, animated: false , scrollPosition: .init())
                cell.isSelected = true
            }
            return cell
            
            // 교과목(value) cell view
            //        } else if collectionView == pageCollectionView {
            //            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath) as? PageCollectionViewCell else { return UICollectionViewCell() }
            //                        lazy var backColor: [UIColor] = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 1, green: 0.8492714985, blue: 0.8835704761, alpha: 1), #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)]
            //
            //            cell.subjectTitle.text = "영어"
            //            // indexPath 에러처리 로직 추가하기
            //            cell.backgroundColor = backColor[indexPath.row]
            //            //            cell.subjectTitle.text = subjectList[indexPath.row]
            //            //            cell.configureCell(color: pageBackgroundColor[indexPath.item])
            //
            //            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
}

extension CategoryMentoListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MentoTableViewCell", for: indexPath) as? MentoTableViewCell else { return UITableViewCell() }
        cell.layer.cornerRadius = 10
        cell.mentoImage.image = UIImage(named: "person.png")
        cell.mentoName.text = "홍길동"
        cell.mentoSubject.text = "수학, 영어"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let CategoryMentoListVC = self.storyboard?.instantiateViewController(withIdentifier: "MentoInfoViewController")
        self.navigationController?.pushViewController(CategoryMentoListVC!, animated: true)
    }
}

extension CategoryMentoListViewController {
    // 스크롤 부드럽게
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //        guard let layout = self.pageTableView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
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
        //            subjecCategoryCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
        //            // collectionView didSelectedItemAt delegate
        //            collectionView(subjecCategoryCollectionView, didSelectItemAt: indexPath)
        //            // topTapMenu Scroll
        //            subjecCategoryCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        //        }
    }
    
}
