//
//  MentoListView.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2022/03/13.
//

import UIKit
import SnapKit
import Then

class MainView: UIView {
    
    let profileImageView = UIImageView().then {
        let image = UIImage(named: "profile.png");
        $0.image = image
        $0.backgroundColor = .yellow
        $0.layer.cornerRadius = 12
    }
    
    let registerMentoButton = UIButton().then {
        var state = "멘토"
        $0.setTitle(state, for: .normal)
        
    }
    
    let nameLabel = UILabel().then {
        $0.font = Fonts.EsamanruOTF.bold.font(size: 22)
        $0.text = "안이연"
        $0.textColor = .black
    }
    
    let name2Label = UILabel().then {
        $0.font = Fonts.EsamanruOTF.medium.font(size: 20)
        $0.text = "님"
        $0.textColor = .black
    }
    
    let mapImageView = UIImageView().then {
        let image = UIImage(named: "map.png");
        $0.image = image
        
    }
    
    let addressLabel = UILabel().then {
        $0.font = Fonts.EsamanruOTF.light.font(size: 12)
        $0.textColor = Colors.Text.text1000.color
        $0.text = "서울특별시 동작구 양녕로 29길 22"
    }
    
    let searchMentoTitleLabel = UILabel().then {
        $0.font = Fonts.EsamanruOTF.bold.font(size: 22)
        $0.textColor = .black
        $0.text = "멘토 찾기"
    }
    
    let img = #imageLiteral(resourceName: "find")
    
    let searchMentoButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "find"), for: .normal)// 이미지 넣기
        $0.setTitle("  어떤 분야의 멘토를 찾으시나요?", for: .normal)
        $0.titleLabel?.textAlignment = .left
        $0.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.cornerRadius = 10
        
//        $0.addTarget(self, action: #selector(setBtnTap), for: .touchUpInside)
    }
    
    @objc
    func setBtnTap() {
        print("setBtnTap")
        
        //present 방식
        
        
        //delegate pattern
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
        }
        
//        if let controller = topVC?.storyboard?.instantiateViewController(withIdentifier: "MentoSearch"){
//            self.navigationController?.pushViewController(controller, animated: true)
//        }

//        let svc = MentoSearchViewController()
//        topVC?.present(svc, animated: true, completion: nil)

        
    }
    
    //    let searchMentoSearchBar = UISearchBar().then {
    //        $0.placeholder = "어떤 분야의 멘토를 찾으시나요?"
    //        $0.searchBarStyle = .minimal
    ////        $0.searchTextField.layer.borderColor = UIColor.black.cgColor
    //        $0.searchTextField.layer.cornerRadius = 10
    ////        $0.searchTextField.layer.borderWidth = 1
    //        $0.searchTextField.largeContentImage?.withTintColor(.black) // 왼쪽 돋보기 모양 커스텀
    ////        $0.searchTextField.borderStyle = .none // 기본으로 있는 회색배경 없애줌
    ////        $0.searchTextField.leftView?.tintColor = .green
    //    }
    
    //    let searchMentoButton = UIButton().then {
    //        $0.setBackgroundColor(.lightGray, for: .normal)
    //
    //        var searchMentoTitle = "어떤 분야의 멘토를 찾으시나요?"
    //        $0.setTitle(searchMentoTitle, for: .normal)
    //        $0.setTitleColor(.black, for: .normal)
    ////        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
    //        $0.titleLabel?.textAlignment = .left
    ////        $0.addTarget(self, action: #selector(touchupSwitchButton(_:)), for: .touchUpInside)
    //    }
    
    let subjectCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        $0.backgroundColor = .white
        $0.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 0)
        $0.showsHorizontalScrollIndicator = false
        $0.collectionViewLayout = layout
    }
    
    
    let mentoListTitleLabel = UILabel().then {
        $0.font = Fonts.EsamanruOTF.bold.font(size: 22)
        $0.textColor = .black
        $0.text = "지금 뜨고 있는 멘토"
    }
    
    let mentoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        $0.backgroundColor = .white
        $0.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 0)
        $0.showsHorizontalScrollIndicator = false
        $0.collectionViewLayout = layout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


extension MainView: ViewRepresentable {
    func setupViews() {
        backgroundColor = .white
        
        // 프로필
        addSubview(profileImageView)
        addSubview(registerMentoButton)
        addSubview(nameLabel)
        addSubview(name2Label)
        addSubview(mapImageView)
        addSubview(addressLabel)
        
        // 멘토찾기
        addSubview(searchMentoTitleLabel)
        addSubview(searchMentoButton)
        //        addSubview(searchMentoButton)
        addSubview(subjectCollectionView)
        
        
        // 지금 뜨고 있는 멘토
        addSubview(mentoListTitleLabel)
        addSubview(mentoCollectionView)
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.top.leading.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        registerMentoButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(profileImageView)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView)
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
        
        name2Label.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing)
            $0.bottom.firstBaseline.equalTo(nameLabel)
        }
        
        mapImageView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView)
            $0.width.height.equalTo(14)
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(mapImageView.snp.trailing).offset(10)
            $0.centerY.equalTo(mapImageView)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        searchMentoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mapImageView.snp.bottom).offset(80)
            $0.leading.equalTo(profileImageView)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        searchMentoButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(searchMentoTitleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(profileImageView)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        //        searchMentoButton.snp.makeConstraints {
        //            $0.top.equalTo(searchMentoTitleLabel.snp.bottom).offset(10)
        //            $0.leading.equalTo(profileImageView)
        ////            $0.trailing.equalToSuperview().offset(-20)
        //        }
        
        subjectCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchMentoButton.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            //            $0.centerY.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        mentoListTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subjectCollectionView.snp.bottom).offset(80)
            $0.leading.equalTo(profileImageView)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        mentoCollectionView.snp.makeConstraints {
            $0.top.equalTo(mentoListTitleLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            //            $0.centerY.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
