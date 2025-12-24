//
//  IconLabelView.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit

class IconLabelView: UIView {
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.footnote()
        label.textColor = AppColors.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.headline(weight: .bold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(icon: UIImage?, iconColor: UIColor, title: String, value: String) {
        super.init(frame: .zero)
        setupView(icon: icon, iconColor: iconColor, title: title, value: value)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(icon: UIImage?, iconColor: UIColor, title: String, value: String) {
        iconContainer.backgroundColor = iconColor.withAlphaComponent(0.1)
        iconContainer.layer.cornerRadius = Layout.CornerRadius.sm
        
        iconImageView.image = icon
        iconImageView.tintColor = iconColor
        titleLabel.text = title
        valueLabel.text = value
        
        iconContainer.addSubview(iconImageView)
        addSubview(iconContainer)
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconContainer.topAnchor.constraint(equalTo: topAnchor),
            iconContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: Layout.IconSize.xl),
            iconContainer.heightAnchor.constraint(equalToConstant: Layout.IconSize.xl),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: Layout.IconSize.md),
            iconImageView.heightAnchor.constraint(equalToConstant: Layout.IconSize.md),
            
            titleLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: Layout.Spacing.sm),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Layout.Spacing.xs),
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
