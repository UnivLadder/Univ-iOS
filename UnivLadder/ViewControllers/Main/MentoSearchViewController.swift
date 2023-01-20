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
        
        registerXib()
        self.subjectListTable.rowHeight  = UITableView.automaticDimension
        self.subjectListTable.estimatedRowHeight = 80
        
        self.subjectListTable.dataSource = self
        self.subjectListTable.delegate = self
        //        let searchController = UISearchController(searchResultsController: nil)
        
        //        subjectSearchBar.delegate = self
        //        self.navigationItem.searchController = searchController
        
        //        setupSearchController()
        
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
        //높이 유동적
        switch indexPath.section{
        case 0:
            return 130
        case 1:
            return 170
        case 2:
            return 40
        case 3:
            return 50
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if isOpen[section] == true {
        //            return 1
        //        } else {
        //            return 0
        //        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{

        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MentoSubjectTableViewCell", for: indexPath) as? MentoSubjectTableViewCell else { return UITableViewCell() }
            cell.setData(list: ["국어", "수학", "영어", "과학", "사회", "한국사", "한문"])
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MentoSubjectTableViewCell", for: indexPath) as? MentoSubjectTableViewCell else { return UITableViewCell() }
            cell.setData(list: ["논술", "인문논술", "수리논술", "과학논술", "국어논술", "소논문", "자소서", "면접", "적성검사", "입시 컨설팅"])
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MentoSubjectTableViewCell", for: indexPath) as? MentoSubjectTableViewCell else { return UITableViewCell() }
            cell.setData(list: ["국어", "수학", "영어", "과학", "사회", "경제"])
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MentoSubjectTableViewCell", for: indexPath) as? MentoSubjectTableViewCell else { return UITableViewCell() }
            cell.setData(list: ["국어", "수학", "영어", "과학", "사회", "경제"])
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
}
