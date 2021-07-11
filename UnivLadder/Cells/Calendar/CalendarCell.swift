//
//  CalendarCell.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/06/13.
//

import UIKit

class CalendarCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: CalendarCell.self)
    
    private lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor(hex: "#6D5AE6")
        return view
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var accessibilityDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
        return dateFormatter
    }()
    
    
    
    var day: Day? {
        didSet {
            guard let day = day else { return }
            numberLabel.text = day.number
            accessibilityLabel = accessibilityDateFormatter.string(from: day.date)
            updateSelectionStatus()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isAccessibilityElement = true
        accessibilityTraits = .button
        
        contentView.addSubview(selectionBackgroundView)
        contentView.addSubview(numberLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.deactivate(selectionBackgroundView.constraints)
        
        // 셀크기 설정 , 원이 셀 - 10까지 늘어나지 않도록 설정
        let size = traitCollection.horizontalSizeClass == .compact ?
            min(min(frame.width, frame.height) - 10, 60) : 45
        
        // 오토레이아웃
        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            selectionBackgroundView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            selectionBackgroundView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
            selectionBackgroundView.widthAnchor.constraint(equalToConstant: size),
            selectionBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor)
        ])
        
        selectionBackgroundView.layer.cornerRadius = size / 2
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        layoutSubviews()
    }
}

// MARK: - Appearance
private extension CalendarCell {
    // 날짜가 선택되면 스타일 반영
    func updateSelectionStatus() {
        guard let day = day else { return }
        
        if day.isSelected {
            applySelectedStyle()
        } else {
            applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth)
        }
    }
    
    // 작은 스크린에선 원대신 글씨색 변경
    var isSmallScreenSize: Bool {
        let isCompact = traitCollection.horizontalSizeClass == .compact
        let smallWidth = UIScreen.main.bounds.width <= 350
        let widthGreaterThanHeight = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        
        return isCompact && (smallWidth || widthGreaterThanHeight)
    }
    
    // 작은 스크린에선 원대신 글씨색 변경
    func applySelectedStyle() {
        accessibilityTraits.insert(.selected)
        accessibilityHint = nil
        
        numberLabel.textColor = isSmallScreenSize ? .systemRed : .white
        selectionBackgroundView.isHidden = isSmallScreenSize
    }
    
    // 셀의 기본 스타일
    func applyDefaultStyle(isWithinDisplayedMonth: Bool) {
        accessibilityTraits.remove(.selected)
        accessibilityHint = "Tap to select"
        
        numberLabel.textColor = isWithinDisplayedMonth ? .black : .secondaryLabel
        selectionBackgroundView.isHidden = true
    }
}
