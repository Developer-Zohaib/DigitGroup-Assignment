//
//  BadgeView.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit

class BadgeView: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption1(weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(text: String, backgroundColor: UIColor, textColor: UIColor = .white) {
        super.init(frame: .zero)
        setupView(text: text, backgroundColor: backgroundColor, textColor: textColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(text: String, backgroundColor: UIColor, textColor: UIColor) {
        self.backgroundColor = backgroundColor
        layer.cornerRadius = Layout.CornerRadius.sm
        
        label.text = text
        label.textColor = textColor
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: Layout.Spacing.xs),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.Spacing.sm),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.Spacing.sm),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Layout.Spacing.xs)
        ])
    }
}
