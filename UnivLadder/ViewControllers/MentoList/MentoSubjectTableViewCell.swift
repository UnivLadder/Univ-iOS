//
//  MentoSubjectTableViewCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/12/04.
//

import UIKit

class MentoSubjectTableViewCell: UITableViewCell{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var subjectList = ["국어", "수학", "영어", "과학", "사회", "사회"]
    static let identifier = "MentoSubjectTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerDelegate()
        registerXib()
        let width = (self.contentView.frame.width-10)/5
//        let height = (self.contentView.frame.height-20)/2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 40)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    private func registerDelegate(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerXib(){
//        let layout = UICollectionViewLayout()
//        collectionView.collectionViewLayout = layout
//
        let storyNib = UINib(nibName: MetnoSubjectCollectionViewCell.identifier, bundle: nil)
        collectionView.register(storyNib, forCellWithReuseIdentifier: MetnoSubjectCollectionViewCell.identifier)
    }
    
    
}

extension MentoSubjectTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 4, height: 2)
    }
}

extension MentoSubjectTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetnoSubjectCollectionViewCell.identifier, for: indexPath) as? MetnoSubjectCollectionViewCell else { return UICollectionViewCell() }
        cell.mentoSubjectLabel.text = "test"
        //        cell.setData(userData: subjectList[indexPath.row])
        return cell
    }
}
