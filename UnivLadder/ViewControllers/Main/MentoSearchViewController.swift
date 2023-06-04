//
//  MentoSearchViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/11/27.
//

import UIKit

class MentoSearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var subjectListTable: UITableView!

    let categoryList = UserDefaultsManager.categoryList
    var subjectDictionary : [String:[String]] = [:]
    
    //section 별 접기 펴기
    //    var isOpen = [Bool]()
    //    var sectionCount = categoryList.count
    //    for i in 0..<11 {
    //        isOpen.append(false)
    //    }
    //    var isOpen = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    
    override func viewDidLoad() {
        self.navigationItem.title = "카테고리"
        super.viewDidLoad()
        dataParsing()
        registerXib()
        self.subjectListTable.dataSource = self
        self.subjectListTable.delegate = self
        setupSearchController()
    }
    
    func dataParsing(){
        let subjects = UserDefaultsManager.subjectList
        
        if let categoryList = categoryList {
            for i in 0..<categoryList.count{
                var tmpArr = [""]
                for j in 0..<subjects!.count{
                    if subjects.map({$0[j].topic})! == categoryList[i]{
                        tmpArr.insert(subjects.map({$0[j].value})!, at: 0)
                    }
                }
                subjectDictionary.updateValue(tmpArr, forKey: categoryList[i])
            }
        }
    }
    
    // tableviewcell xid 등록
    private func registerXib(){
        //swift file name
        let storyNib = UINib(nibName: "MentoSubjectTableViewCell", bundle: nil)
        //cell identifier name
        subjectListTable.register(storyNib, forCellReuseIdentifier: "MentoSubjectTableViewCell")
    }
    
    //searchbar 등록
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "어떤 수업을 찾으시나요?"
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}

//extension MentoSearchViewController: UISearchResultsUpdating{
//    func updateSearchResults(for searchController: UISearchController) {
//        dump(subjectSearchBar.text)
//    }
//}

extension MentoSearchViewController : UITableViewDelegate, UITableViewDataSource {
    //category로 section 분류
    func numberOfSections(in tableView: UITableView) -> Int {
        if let categoryList = categoryList{
            return categoryList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        
        let imageView = UIImageView()
        let image = UIImage(systemName: "checkmark.circle")
        imageView.image = image
        imageView.tintColor = .systemPink
        
        let label = UILabel()
        if let categoryList = categoryList{
            label.text = categoryList[section]
        }else{
            label.text = "기타"
        }
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        
        let customView = UIView(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width, height: 30))
        customView.addSubview(stackView)
        
        headerView.backgroundColor = .white
        headerView.addSubview(customView)
        
        return headerView
    }
    
    //tableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //높이 셀의 개수에 따라 유동적으로

        let cellCount = subjectDictionary[categoryList![indexPath.section]]!.count
        print(cellCount)
        let totalHeight = tableView.bounds.height - (tableView.contentInset.top + tableView.contentInset.bottom)
        let cellHeight = totalHeight / CGFloat(cellCount)
        print(cellHeight)
        return CGFloat(cellCount)*10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MentoSubjectTableViewCell", for: indexPath) as? MentoSubjectTableViewCell else { return UITableViewCell() }
        
        cell.setData(list: subjectDictionary[categoryList![indexPath.section]]!)
        return cell
    }
}
