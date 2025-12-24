//
//  AppointmentTableViewCell.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit

class AppointmentTableViewCell: UITableViewCell {
    
    static let identifier = "AppointmentTableViewCell"
    
    private let cardView: CardView = {
        let card = CardView()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    private let avatarView: AvatarImageView = {
        let avatar = AvatarImageView(size: Layout.AvatarSize.md, showOnlineIndicator: true)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.headline(weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.headline(weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let topRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.distribution = .fill
        stack.spacing = Layout.Spacing.sm
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let specialtyLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.subheadline()
        label.textColor = AppColors.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let locationIcon: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = AppColors.textTertiary
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption1()
        label.textColor = AppColors.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        
        topRowStack.addArrangedSubview(nameLabel)
        topRowStack.addArrangedSubview(timeLabel)
        
        locationContainer.addSubview(locationIcon)
        locationContainer.addSubview(locationLabel)
        
        cardView.addSubview(avatarView)
        cardView.addSubview(topRowStack)
        cardView.addSubview(specialtyLabel)
        cardView.addSubview(locationContainer)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.Spacing.xs),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.Spacing.xs),
            
            avatarView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Layout.Padding.card),
            avatarView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Layout.Padding.card),
            avatarView.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -Layout.Padding.card),
            
            topRowStack.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: Layout.Spacing.md),
            topRowStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Layout.Padding.card),
            topRowStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Layout.Padding.card),
            
            specialtyLabel.leadingAnchor.constraint(equalTo: topRowStack.leadingAnchor),
            specialtyLabel.topAnchor.constraint(equalTo: topRowStack.bottomAnchor, constant: Layout.Spacing.xs),
            specialtyLabel.trailingAnchor.constraint(equalTo: topRowStack.trailingAnchor),
            
            locationContainer.leadingAnchor.constraint(equalTo: topRowStack.leadingAnchor),
            locationContainer.topAnchor.constraint(equalTo: specialtyLabel.bottomAnchor, constant: Layout.Spacing.sm),
            locationContainer.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -Layout.Padding.card),
            locationContainer.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Layout.Padding.card),
            
            locationIcon.leadingAnchor.constraint(equalTo: locationContainer.leadingAnchor),
            locationIcon.centerYAnchor.constraint(equalTo: locationContainer.centerYAnchor),
            locationIcon.widthAnchor.constraint(equalToConstant: Layout.IconSize.xs),
            locationIcon.heightAnchor.constraint(equalToConstant: Layout.IconSize.xs),
            
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: Layout.Spacing.xs),
            locationLabel.trailingAnchor.constraint(equalTo: locationContainer.trailingAnchor),
            locationLabel.topAnchor.constraint(equalTo: locationContainer.topAnchor),
            locationLabel.bottomAnchor.constraint(equalTo: locationContainer.bottomAnchor)
        ])
    }
    
    func configure(
        doctorName: String,
        specialty: String,
        time: String,
        timeColor: UIColor,
        location: String,
        showVideoIcon: Bool,
        showOnline: Bool
    ) {
        nameLabel.text = doctorName
        specialtyLabel.text = specialty
        timeLabel.text = time
        timeLabel.textColor = timeColor
        locationLabel.text = location
        locationIcon.image = showVideoIcon ? AppAssets.Icons.video : AppAssets.Icons.location
        
        avatarView.setImage(AppAssets.Icons.personCircle)
        avatarView.setOnlineStatus(showOnline)
        
        configureAccessibility(
            doctorName: doctorName,
            specialty: specialty,
            time: time,
            location: location,
            isVideo: showVideoIcon,
            isOnline: showOnline
        )
    }
    
    private func configureAccessibility(
        doctorName: String,
        specialty: String,
        time: String,
        location: String,
        isVideo: Bool,
        isOnline: Bool
    ) {
        isAccessibilityElement = true
        accessibilityTraits = .button
        
        let appointmentType = isVideo ? "Video consultation" : "In-person appointment"
        let onlineStatus = isOnline ? "Doctor is online" : ""
        
        accessibilityLabel = "\(doctorName), \(specialty). \(appointmentType) at \(time). Location: \(location). \(onlineStatus)"
        accessibilityHint = "Double tap to view appointment details"
    }
}
