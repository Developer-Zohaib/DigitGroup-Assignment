//
//  SectionHeaderView.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit

class SectionHeaderView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption1(weight: .semibold)
        label.textColor = AppColors.textTertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        setupView(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(title: String) {
        titleLabel.text = title.uppercased()
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Layout.Spacing.lg),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Layout.Spacing.sm)
        ])
    }
}
