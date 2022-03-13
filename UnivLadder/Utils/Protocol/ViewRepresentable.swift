//
//  ViewRepresentable.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2022/03/13.
//

import Foundation

protocol ViewRepresentable: AnyObject {
    func setupViews()
    func setupConstraints()
}
