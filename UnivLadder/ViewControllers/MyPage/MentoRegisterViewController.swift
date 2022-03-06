//
//  MentoRegisterViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/03/06.
//

import UIKit

class MentoRegisterViewController: UIViewController {

    @IBOutlet weak var subjectCollectionView: UICollectionView!

    var subjectList = ["교과목", "수시/논술", "입시/경시대회", "외국어" ,"외국어 시험", "미술", "음악", "악기", "국악", "댄스", "IT/컴퓨터", "디자인", "취업 준비", "스포츠", "패션/뷰티", "사진/영상", "연기/공연/영화", "요리/커피"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension MentoRegisterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //선택시 데이터 저장 및 코너 컬러 변경 로직 추가 필요
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCell", for: indexPath) as! SubjectCollectionViewCell
        
        cell.backgroundColor = .white
        
        cell.subjectLabel.text = subjectList[indexPath.row]
//        cell.lbl.backgroundColor = .yellow
//
        if indexPath.item == 0 {
              cell.isSelected = true
          }
          
        return cell
    }
    
}

extension MentoRegisterViewController: UICollectionViewDelegateFlowLayout {

    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // cell 사이즈( 옆 라인을 고려하여 설정 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width / 3 - 10 ///  3등분하여 배치, 옆 간격이 10이므로 10을 빼줌
        print("collectionView width=\(collectionView.frame.width)")
        print("cell하나당 width=\(width)")
        print("root view width = \(self.view.frame.width)")

        let height = collectionView.frame.width / 3 - 70
        let size = CGSize(width: width, height: height)
        
        return size
    }
}
