//
//  MentoListView.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2022/03/13.
//

import UIKit

class MentoListView: UIView {
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
    }
    
    func setupConstraints() {
        
    }
}
