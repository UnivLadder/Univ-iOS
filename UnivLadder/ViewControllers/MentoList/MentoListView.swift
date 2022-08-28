//
//  MontoListView.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/08/14.
//

import UIKit

class MentoListView: UIView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        $0.backgroundColor = .white
        $0.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 0)
        $0.showsHorizontalScrollIndicator = false
        $0.collectionViewLayout = layout
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bindConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        bindConstraints()
    }
    
    func setup() {
        backgroundColor = .white
        addSubview(collectionView)
    }
    
    func bindConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(100)
        }
    }
}
//let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
//    let layout = UICollectionViewFlowLayout()
//    layout.scrollDirection = .horizontal
//
//    $0.backgroundColor = .white
//    $0.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 0)
//    $0.showsHorizontalScrollIndicator = false
//    $0.collectionViewLayout = layout
//}
