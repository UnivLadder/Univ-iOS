//
//  CategoryCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/05/28.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    static let categoryRegisterId = "\(MentoListCell.self)"
    
    let label = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = Fonts.EsamanruOTF.medium.font(size: 20)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let main = UIView().then {
        $0.layer.cornerRadius = 10
    }
    
    let imageView = UIImageView()
    
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
        addSubview(label)
    }
    
    private func bindConstraints() {
        main.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(main.snp.top)
            $0.leading.equalTo(main.snp.leading)
            $0.trailing.equalTo(main.snp.trailing)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalTo(imageView)
//            $0.top.equalTo(imageView.snp.top).offset(40)
            $0.leading.equalTo(main.snp.leading)
            $0.trailing.equalTo(main.snp.trailing)
        }
    }
}
