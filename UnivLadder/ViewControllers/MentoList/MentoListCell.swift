//
//  MentoListCell.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/08/28.
//

import UIKit

class MentoListCell: UICollectionViewCell {
    
    static let mentoRegisterId = "\(MentoListCell.self)"
    
    let label = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let main = UIView()
    let tvImageView = UIImageView()
    
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
        addSubview(tvImageView)
        addSubview(label)
    }
    
    private func bindConstraints() {
        main.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tvImageView.snp.makeConstraints {
            $0.top.equalTo(main.snp.top)
            $0.leading.equalTo(main.snp.leading)
            $0.trailing.equalTo(main.snp.trailing)
            $0.height.equalTo(80)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(main.snp.top).offset(85)
            $0.leading.equalTo(main.snp.leading)
            $0.trailing.equalTo(main.snp.trailing)
        }
    }
}
