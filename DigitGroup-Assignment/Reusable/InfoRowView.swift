//
//  InfoRowView.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit

class InfoRowView: UIView {
    
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
        label.font = AppFonts.headline(weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.subheadline()
        label.textColor = AppColors.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = AppAssets.Icons.rightArrow
        iv.tintColor = AppColors.textTertiary
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    init(icon: UIImage?, iconColor: UIColor, title: String, subtitle: String, showChevron: Bool = true) {
        super.init(frame: .zero)
        setupView(icon: icon, iconColor: iconColor, title: title, subtitle: subtitle, showChevron: showChevron)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(icon: UIImage?, iconColor: UIColor, title: String, subtitle: String, showChevron: Bool) {
        iconContainer.backgroundColor = iconColor.withAlphaComponent(0.1)
        iconContainer.layer.cornerRadius = Layout.CornerRadius.sm
        
        iconImageView.image = icon
        iconImageView.tintColor = iconColor
        titleLabel.text = title
        subtitleLabel.text = subtitle
        chevronImageView.isHidden = !showChevron
        
        iconContainer.addSubview(iconImageView)
        addSubview(iconContainer)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            iconContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: Layout.IconSize.xl),
            iconContainer.heightAnchor.constraint(equalToConstant: Layout.IconSize.xl),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: Layout.IconSize.md),
            iconImageView.heightAnchor.constraint(equalToConstant: Layout.IconSize.md),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: Layout.Spacing.md),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Layout.Spacing.sm),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -Layout.Spacing.sm),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Layout.Spacing.xs),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Layout.Spacing.sm),
            
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: Layout.IconSize.xs),
            chevronImageView.heightAnchor.constraint(equalToConstant: Layout.IconSize.xs)
        ])
    }
}
