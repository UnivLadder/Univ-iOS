//
//  AccountModifyViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/10/09.
//

import UIKit

class AccountModifyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var Picker = UIImagePickerController()
    
    @IBOutlet weak var accountImg: UIImageView!
    @IBOutlet weak var accountImgModifyBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInit()
        
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
    
    /// 이미지 변경 버튼 클릭시 생성되는 action sheet
    func showActionSheet() {
        
        // 액션 시트 초기화
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // UIAlertAction 설정
        // handler : 액션 발생시 호출
        let actionCamera = UIAlertAction(title: "사진 촬영", style: .default, handler: {(alert:UIAlertAction!) -> Void in
            self.openCamera()
        })
        let actionAlbum = UIAlertAction(title: "앨범에서 가져오기", style: .default, handler: {(alert:UIAlertAction!) -> Void in
            self.openGallery()
        })
        let actionFile = UIAlertAction(title: "파일 선택", style: .default, handler: nil)
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionSheet.addAction(actionCamera)
        actionSheet.addAction(actionAlbum)
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
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.accountImg.image = (info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage)
        self.dismiss(animated: true, completion: nil)
        
    }
}
