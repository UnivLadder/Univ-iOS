//
//  MentoRegisterSubjectViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/06/18.
//

import UIKit

class MentoRegisterSubjectViewController: UIViewController {
    
    //과목 리스트
    var subjectList: [String] = []
    var selectedSubjectList: [String] = []
    var categoryName = ""
    var delegate: SendData?

    @IBOutlet weak var subjectCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var confirmBtn: UIButton!{
        didSet{
            confirmBtn.layer.cornerRadius = 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectCollectionView.allowsMultipleSelection = true
        subjectList = UserDefaultsManager.subjectDictionary![categoryName]!
    }
    

    @IBAction func sendMentoCategorySubjects(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MentoRegister") as! MentoRegisterViewController
        self.delegate?.sendData(subjects: selectedSubjectList)
        self.navigationController?.popViewController(animated: true)
    }
}

extension MentoRegisterSubjectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCell", for: indexPath) as! SubjectCollectionViewCell
        cell.backgroundColor = .white
        cell.subjectLabel.text = subjectList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SubjectCollectionViewCell else{
            fatalError()
        }
        
        selectedSubjectList.append(subjectList[indexPath.row])
        cell.isSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SubjectCollectionViewCell else{
            fatalError()
        }
        
        if let indexRow = selectedSubjectList.firstIndex(of: subjectList[indexPath.row]) {
            selectedSubjectList.remove(at: indexRow)
        }
        cell.isSelected = false
    }
}

extension MentoRegisterSubjectViewController: UICollectionViewDelegateFlowLayout {
    
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
        let height = collectionView.frame.width / 3 - 70
        let size = CGSize(width: width, height: height)
        
        return size
    }
}
