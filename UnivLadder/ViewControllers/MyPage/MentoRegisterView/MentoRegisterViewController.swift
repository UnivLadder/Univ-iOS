//
//  MentoRegisterViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/03/06.
//

import UIKit

//StoryboardId : MentoRegister
class MentoRegisterViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var registerMentoBtn: UIButton!{
        didSet{
            registerMentoBtn.layer.cornerRadius = 10
            if UserDefaults.standard.integer(forKey: "MyMentoId") > 0 {
                registerMentoBtn.setTitle("확인", for: .normal)
            }else{
                registerMentoBtn.setTitle("다음", for: .normal)
            }
        }
    }
    
//    var cellList: [String] = []
    var didSelectItemAction: ((IndexPath) -> Void)?
    
    //카테고리 리스트
    var categoryList = UserDefaultsManager.categoryList

    // 멘토 등록시 전송될 선택된 과목들
    var mentoSubjects: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionView.allowsMultipleSelection = true
        UserDefaultsManager.selectedSubject = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    // 분야 선택 완료 버튼
    @IBAction func registerMentoBtnAction(_ sender: Any) {
        // 멘토 등록 되어있는 경우
        // 확인으로 하고 멘토 수업 과목 생성 API 수행
        if UserDefaults.standard.integer(forKey: "MyMentoId") > 0 {
            registerMentoBtn.titleLabel?.text = "확인"
            if let accesstoken = UserDefaults.standard.string(forKey: "accessToken"){
                
            }

        }else{
            registerMentoBtn.titleLabel?.text = "다음"
            // 멘토 등록 안 되어있는 경우 - 상세 서비스 설정 화면 이동
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "MentoInfo") as? MentoDetailModifyViewController
            //선택한 과목 코드 전달
//            pushVC?.extracurricularSubjectCodes = mentoSubjects
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }
    }
}

//extension MentoRegisterViewController: SendData {
//    func sendData(subjects: [Int]) {
//        mentoSubjects += subjects
//    }
//}

extension MentoRegisterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //선택한 과목 저장 및 서버 전송 로직 추가 필요
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pushVC = self.storyboard?.instantiateViewController(identifier: "MentoRegisterSubject") as? MentoRegisterSubjectViewController else {
            return
        }
//        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "MentoRegisterSubject")
        pushVC.categoryName = categoryList![indexPath.row]
//        pushVC.delegate = self
        self.navigationController?.pushViewController(pushVC, animated: true)
                
        
//        self.selectedSubjects.append(subjectList[indexPath.row])
//        print(self.selectedSubjects)
        
        // 현재 리스트
        // 1. 카테고리 : 선택시 과목 리스트로 변경
        
        // 2. 과목 :
//        didSelectItemAction?(indexPath.row)
    }
    
    //선택 취소한 과목 삭제
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
//        for index in 0..<(selectedSubjects.count-1) {
//            if self.selectedSubjects[index] == (self.cellList[indexPath.row]){
//                self.selectedSubjects.remove(at: index)
//                print(self.selectedSubjects)
//            }
            
            //            if self.selectedSubjects.contains(self.subjectList[indexPath.row]){
            //                self.selectedSubjects.remove(at: index-1)
            //                print(self.selectedSubjects)
            //            }
//        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCell", for: indexPath) as! SubjectCollectionViewCell
        cell.backgroundColor = .white
        cell.subjectLabel.text = categoryList![indexPath.row]
        
        //사용자의 기존 선택한 과목 보여주기
//        if {
//            cell.isSelected = true
//        }
        
        
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
        let height = collectionView.frame.width / 3 - 70
        let size = CGSize(width: width, height: height)
        
        return size
    }
}
