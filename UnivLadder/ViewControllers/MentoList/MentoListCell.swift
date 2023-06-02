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

    let main = UIView().then {
        $0.layer.cornerRadius = 50
    }
    
    let tvImageView = UIImageView()

    let imageView = UIImageView().then{
        let customImage = UIImage(named: "person.png")
        let newWidth = 80
        let newHeight = 80
        let newImageRect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        customImage?.draw(in: newImageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
        UIGraphicsEndImageContext()
        
        $0.image = newImage
        $0.layer.cornerRadius = CGFloat(newHeight/2)
        $0.clipsToBounds = true
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
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(main.snp.top).offset(80)
            $0.leading.equalTo(main.snp.leading)
            $0.trailing.equalTo(main.snp.trailing)
        }
    }
}
