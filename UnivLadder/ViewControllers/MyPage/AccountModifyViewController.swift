//
//  AccountModifyViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/10/09.
//

import UIKit
import CoreData

class AccountModifyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var Picker = UIImagePickerController()
    var container: NSPersistentContainer!
    var accountImgURL = ""
    @IBOutlet weak var accountImg: UIImageView!
    @IBOutlet weak var accountImgModifyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInit()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
    }
    
    func viewInit() {
        accountImg.layer.cornerRadius = accountImg.frame.height/2
        accountImgModifyBtn.layer.cornerRadius = accountImgModifyBtn.frame.height/2
        accountImgModifyBtn.setTitle("", for: .normal)
    }
    
    /// 계정 정보 이미지 변경 버튼
    /// - Parameter sender: sender
    @IBAction func accountImgModifyAction(_ sender: Any) {
        showActionSheet()
    }
    
    //계정 정보 수정 반영
    @IBAction func saveModifiedUserInfoAction(_ sender: Any) {
//        let alert = UIAlertController(title:"변경사항 저장 성공",
//                                      message: nil,
//                                      preferredStyle: UIAlertController.Style.alert)
//        //2. 확인 버튼 만들기
//        let buttonLabel = UIAlertAction(title: "확인", style: .default, handler: nil)
//        //3. 확인 버튼을 경고창에 추가하기
//        alert.addAction(buttonLabel)
//        //4. 경고창 보이기
//        present(alert,animated: true,completion: nil)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: context) as! UserEntity
//        let png = accountImg.image?.pngData()
        user.thumbnail = self.accountImgURL
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    
    /// 이미지 변경 버튼 클릭시 생성되는 action sheet
    func showActionSheet() {
        
        // 액션 시트 초기화
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // UIAlertAction 설정
        // handler : 액션 발생시 호출
        let actionAlbum = UIAlertAction(title: "사진 등록하기", style: .default, handler: {(alert:UIAlertAction!) -> Void in
            self.openGallery()
        })
        let actionCamera = UIAlertAction(title: "사진 찍기", style: .default, handler: {(alert:UIAlertAction!) -> Void in
            self.openCamera()
        })
        let actionFile = UIAlertAction(title: "기본 이미지로 변경", style: .default, handler: {(alert:UIAlertAction!) -> Void in
            //기존 이미지로 변경
            self.accountImg.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), renderingMode: .alwaysOriginal)
        })
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionSheet.addAction(actionAlbum)
        actionSheet.addAction(actionCamera)
        actionSheet.addAction(actionFile)
        actionSheet.addAction(actionCancel)
        
        self.present(actionSheet, animated: true)
    }
    
    /// actionsheet1. 카메라 촬영
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            self.Picker.sourceType = UIImagePickerController.SourceType.camera;
            self .present(self.Picker, animated: true, completion: nil)
            self.Picker.allowsEditing = false
            self.Picker.delegate = self
        }
    }
    
    /// actionsheet2. 앨범에서 가져오기
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum){
            self.Picker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum;
            self.Picker.allowsEditing = false
            self.Picker.delegate = self
            self.present(self.Picker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Image Picker Delegate methods
    //사진 이미지 선택 취소 시 호출
    //    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    //        self.dismiss(animated: true, completion: nil)
    //    }
    //
    //    //사진 이미지 선택시 호출
    //    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    //        if let selectedImg = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
    //        {
    //            self.accountImg.image = selectedImg
    //            //local db 저장
    //            let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    //            let context = container.viewContext
    //            let userEntity = UserEntity(context: context)
    //            userEntity.thumbnail = selectedImg.toPngString()
    //        }
    //        self.dismiss(animated: true, completion: nil)
    //    }
    //
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //선택한 이미지로 이미지 보여주기
            self.accountImg.image = image
            //            let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
            //            let context = container.viewContext
            //            let userEntity = UserEntity(context: context)
            //            userEntity.thumbnail = image.toPngString()
        }
        
        //선택한 이미지 url 저장 보여주기
        if let imgURL =  info[UIImagePickerController.InfoKey.imageURL] as? NSURL{
            accountImgURL = imgURL.absoluteString!
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
    
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
