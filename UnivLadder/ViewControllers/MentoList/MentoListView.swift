//
//  MentoListView.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2022/03/13.
//

import UIKit
import Then

class MentoListView: UIView {
    let profileImageView = UIImageView().then {
        $0.backgroundColor = .yellow
        $0.layer.cornerRadius = 12
    }
    
    let registerMentoButton = UIButton().then {
        $0.setTitle("멘토등록하기", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension MentoListView: ViewRepresentable {
    func setupViews() {
        backgroundColor = .white
        addSubview(profileImageView)
        addSubview(registerMentoButton)
    }
    
    func setupConstraints() {
        
    }
}
