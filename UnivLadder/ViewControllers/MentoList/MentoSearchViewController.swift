//
//  MentoSearchViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/11/27.
//

import UIKit

class MentoSearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var subjectListTable: UITableView!
    @IBOutlet weak var subjectSearchBar: UISearchBar!
    var categoryList = ["교과목", "수시/논술", "입시/경시대회", "외국어" ,"외국어 시험", "미술", "음악", "악기", "국악", "댄스", "IT/컴퓨터", "디자인", "취업 준비", "스포츠", "패션/뷰티", "사진/영상", "연기/공연/영화", "요리/커피"]
    
    //section 별 접기 펴기
//    var isOpen = [Bool]()
//    var sectionCount = categoryList.count
//    for i in 0..<11 {
//        isOpen.append(false)
//    }
    var isOpen = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    
    override func viewDidLoad() {
        self.navigationItem.title = "카테고리"
        super.viewDidLoad()
        subjectSearchBar.delegate = self
        registerXib()
        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchBar = subjectSearchBar
        self.navigationItem.searchController = searchController
        
//        setupSearchController()

    }
    
    // tableviewcell 등록
    private func registerXib(){
        let storyNib = UINib(nibName: MentoSubjectTableViewCell.identifier, bundle: nil)
        subjectListTable.register(storyNib, forCellReuseIdentifier: MentoSubjectTableViewCell.identifier)
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

extension MentoSearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        dump(subjectSearchBar.text)
    }
}

extension MentoSearchViewController : UITableViewDelegate, UITableViewDataSource {
    //section
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categoryList[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        header.textLabel?.font = UIFont.systemFont(ofSize: 17)
    }
    
    //tableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isOpen[section] == true {
            return 1
        } else {
            return 0
        }
//        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MentoSubjectTableViewCell.identifier, for: indexPath) as? MentoSubjectTableViewCell else { return UITableViewCell() }
                    return cell
//        let cell = subjectListTable.dequeueReusableCell(withIdentifier: "MentoSubjectTableViewCell", for: indexPath) as! MentoSubjectTableViewCell
//        return cell
    }

}
