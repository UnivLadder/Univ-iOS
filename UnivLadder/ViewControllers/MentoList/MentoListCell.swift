//
//  MentoListCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/08/28.
//

import UIKit

class MentoListCell: UICollectionViewCell {
    
    static let registerId = "\(MentoListCell.self)"
    
    let label = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
//    private let imageView = UIImageView()

    let main = UIView().then {
        $0.layer.cornerRadius = 10
//        $0.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    }
    
    let tvImageView = UIImageView()
//
    let imageView = UIImageView().then{
        $0.layer.cornerRadius = 10
        $0.image = UIImage(named: "외국어.png")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bindConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        addSubview(main)
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
//        imageView.backgroundColor = .tertiaryLabel
        addSubview(label)
    }
    
    private func bindConstraints() {
        main.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(main.snp.top).offset(40)
//            $0.top.equalTo(main.snp.leading)
//            $0.leading.equalTo(main.snp.leading)
            $0.leading.equalTo(main.snp.leading)
            $0.trailing.equalTo(main.snp.trailing)
        }
    }
}
