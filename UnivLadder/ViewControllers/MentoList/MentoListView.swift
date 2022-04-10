//
//  MentoListView.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2022/03/13.
//

import UIKit
import SnapKit
import Then

class MentoListView: UIView {
    let profileImageView = UIImageView().then {
        $0.backgroundColor = .yellow
        $0.layer.cornerRadius = 12
    }
    
    let registerMentoButton = UIButton().then {
        $0.setTitle("멘토등록하기", for: .normal)
        $0.backgroundColor = .yellow
    }
    
    let nameLabel = UILabel().then {
        $0.font = Fonts.EsamanruOTF.bold.font(size: 22)
        $0.text = "김연진"
        $0.textColor = .black
    }
    
    let name2Label = UILabel().then {
        $0.font = Fonts.EsamanruOTF.medium.font(size: 20)
        $0.text = "님"
        $0.textColor = .black
    }
    
    let mapImageView = UIImageView().then {
        $0.backgroundColor = .yellow
    }
    
    let addressLabel = UILabel().then {
        $0.font = Fonts.EsamanruOTF.light.font(size: 12)
        $0.textColor = Colors.Text.text1000.color
        $0.text = "서울특별시 동작구"
    }
    
    let searchMentoTitleLabel = UILabel().then {
        $0.font = Fonts.EsamanruOTF.bold.font(size: 22)
        $0.textColor = .black
        $0.text = "멘토 찾기"
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

extension MentoListView: ViewRepresentable {
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
    }
}
