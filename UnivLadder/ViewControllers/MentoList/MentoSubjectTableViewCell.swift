//
//  MentoSubjectTableViewCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/12/04.
//

import UIKit

// 과목 테이블 뷰 셀
class MentoSubjectTableViewCell: UITableViewCell{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var subjectList = [""]
    
    static let identifier = "MentoSubjectTableViewCell"
    var didSelectItemAction: ((IndexPath) -> Void)?
//    var subjectList: [String] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerDelegate()
        registerXib()
        collectionView.layer.cornerRadius = 10
        
        let width = (self.contentView.frame.width-10)/3
        //        let height = (self.contentView.frame.height-20)/2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //cell 크기
        layout.itemSize = CGSize(width: width, height: 35)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func registerDelegate(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerXib(){
        let storyNib = UINib(nibName: MetnoSubjectCollectionViewCell.identifier, bundle: nil)
        collectionView.register(storyNib, forCellWithReuseIdentifier: MetnoSubjectCollectionViewCell.identifier)
    }
    
    func setData(list: [String]){
        subjectList = list
    }
}

extension MentoSubjectTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 10, height: 2)
    }

}

extension MentoSubjectTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetnoSubjectCollectionViewCell.identifier, for: indexPath) as? MetnoSubjectCollectionViewCell else { return UICollectionViewCell() }
        
        //cell label 값 넣기
        cell.mentoSubjectLabel.text = subjectList[indexPath.item]
        //추후 과목별 멘토 수 label 추가
        //        cell.subjectCountLabel.text = "(000)"
        //        cell.setData(userData: subjectList[indexPath.row])
        return cell
    }
    
    //과목 선택시 해당 카테고리별 과목 테이블뷰로 이동
    // storyboard id : CategoryMentoList
    // VC : CategoryMentoListViewController
    //segue로 이동 : CategoryMentoSegue
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 과목
        print(subjectList[indexPath.item])
        
        didSelectItemAction?(indexPath)
        
    }
    

}
