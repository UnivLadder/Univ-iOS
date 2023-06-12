//
//  ViewRepresentable.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/09/13.
//

import Foundation

protocol ViewRepresentable: AnyObject {
    func setupViews()
    func setupConstraints()
}
