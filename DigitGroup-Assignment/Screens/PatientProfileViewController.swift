//
//  PatientProfileViewController.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit
import Combine

class PatientProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: PatientProfileViewModelProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarView = AvatarImageView(size: Layout.AvatarSize.xl, showOnlineIndicator: true)
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jane Doe"
        label.font = AppFonts.title2(weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "34 yrs • Female"
        label.font = AppFonts.subheadline()
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = Layout.Spacing.md
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let medicalDetailsSection = SectionHeaderView(title: "Medical Details")
    private let administrativeSection = SectionHeaderView(title: "Administrative")
    
    private let medicalCard = CardView()
    private let administrativeCard = CardView()
    
    // MARK: - Configuration
    
    func configure(with viewModel: PatientProfileViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bindViewModel()
        viewModel?.viewDidLoad()
    }
    
    // MARK: - Bindings
    
    private func bindViewModel() {
        viewModel?.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: PatientProfileViewModel.State) {
        switch state {
        case .idle:
            break
        case .loading:
            break
        case .loaded(let data):
            updateUI(with: data)
        case .error(let message):
            showError(message)
        }
    }
    
    private func updateUI(with data: PatientProfileViewModel.ProfileData) {
        nameLabel.text = data.fullName
        infoLabel.text = "\(data.age) yrs"
        avatarView.setOnlineStatus(data.isOnline)
        
        updateStatsViews(blood: data.bloodType, height: data.height, weight: data.weight)
        updateMedicalCard(allergies: data.allergies, conditions: data.conditions, medications: data.medications)
        updateAdministrativeCard(
            insurance: "\(data.insuranceProvider) • ID #\(data.insuranceId)",
            emergency: "\(data.emergencyContactName) (\(data.emergencyContactRelation))"
        )
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupUI() {
        title = "Profile"
        view.backgroundColor = AppColors.background
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        medicalDetailsSection.translatesAutoresizingMaskIntoConstraints = false
        administrativeSection.translatesAutoresizingMaskIntoConstraints = false
        medicalCard.translatesAutoresizingMaskIntoConstraints = false
        administrativeCard.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(statsStackView)
        contentView.addSubview(medicalDetailsSection)
        contentView.addSubview(medicalCard)
        contentView.addSubview(administrativeSection)
        contentView.addSubview(administrativeCard)
        
        setupStatsViews()
        setupMedicalCard()
        setupAdministrativeCard()
    }
    
    private func setupStatsViews() {
        let bloodView = IconLabelView(icon: AppAssets.Icons.drop, iconColor: AppColors.bloodType, title: "BLOOD", value: "A+")
        let heightView = IconLabelView(icon: AppAssets.Icons.ruler, iconColor: AppColors.height, title: "HEIGHT", value: "170 cm")
        let weightView = IconLabelView(icon: AppAssets.Icons.scalemass, iconColor: AppColors.weight, title: "WEIGHT", value: "65 kg")
        
        statsStackView.addArrangedSubview(bloodView)
        statsStackView.addArrangedSubview(heightView)
        statsStackView.addArrangedSubview(weightView)
    }
    
    private func setupMedicalCard() {
        let allergiesRow = InfoRowView(
            icon: AppAssets.Icons.exclamationTriangle,
            iconColor: AppColors.error,
            title: "Allergies",
            subtitle: "Peanuts, Penicillin",
            showChevron: true
        )
        
        let conditionsRow = InfoRowView(
            icon: AppAssets.Icons.cross,
            iconColor: AppColors.info,
            title: "Chronic Conditions",
            subtitle: "Hypertension",
            showChevron: true
        )
        
        let medicationsRow = InfoRowView(
            icon: AppAssets.Icons.pills,
            iconColor: AppColors.warning,
            title: "Current Medications",
            subtitle: "Lisinopril 10mg",
            showChevron: true
        )
        
        allergiesRow.translatesAutoresizingMaskIntoConstraints = false
        conditionsRow.translatesAutoresizingMaskIntoConstraints = false
        medicationsRow.translatesAutoresizingMaskIntoConstraints = false
        
        medicalCard.addSubview(allergiesRow)
        medicalCard.addSubview(conditionsRow)
        medicalCard.addSubview(medicationsRow)
        
        NSLayoutConstraint.activate([
            allergiesRow.topAnchor.constraint(equalTo: medicalCard.topAnchor, constant: Layout.Padding.card),
            allergiesRow.leadingAnchor.constraint(equalTo: medicalCard.leadingAnchor, constant: Layout.Padding.card),
            allergiesRow.trailingAnchor.constraint(equalTo: medicalCard.trailingAnchor, constant: -Layout.Padding.card),
            
            conditionsRow.topAnchor.constraint(equalTo: allergiesRow.bottomAnchor, constant: Layout.Spacing.md),
            conditionsRow.leadingAnchor.constraint(equalTo: medicalCard.leadingAnchor, constant: Layout.Padding.card),
            conditionsRow.trailingAnchor.constraint(equalTo: medicalCard.trailingAnchor, constant: -Layout.Padding.card),
            
            medicationsRow.topAnchor.constraint(equalTo: conditionsRow.bottomAnchor, constant: Layout.Spacing.md),
            medicationsRow.leadingAnchor.constraint(equalTo: medicalCard.leadingAnchor, constant: Layout.Padding.card),
            medicationsRow.trailingAnchor.constraint(equalTo: medicalCard.trailingAnchor, constant: -Layout.Padding.card),
            medicationsRow.bottomAnchor.constraint(equalTo: medicalCard.bottomAnchor, constant: -Layout.Padding.card)
        ])
    }
    
    private func setupAdministrativeCard() {
        let insuranceRow = InfoRowView(
            icon: AppAssets.Icons.shield,
            iconColor: AppColors.secondary,
            title: "Insurance",
            subtitle: "BlueCross • ID #8849302",
            showChevron: true
        )
        
        let emergencyRow = InfoRowView(
            icon: AppAssets.Icons.phoneCircle,
            iconColor: AppColors.success,
            title: "Emergency Contact",
            subtitle: "John Doe (Husband)",
            showChevron: true
        )
        
        insuranceRow.translatesAutoresizingMaskIntoConstraints = false
        emergencyRow.translatesAutoresizingMaskIntoConstraints = false
        
        administrativeCard.addSubview(insuranceRow)
        administrativeCard.addSubview(emergencyRow)
        
        NSLayoutConstraint.activate([
            insuranceRow.topAnchor.constraint(equalTo: administrativeCard.topAnchor, constant: Layout.Padding.card),
            insuranceRow.leadingAnchor.constraint(equalTo: administrativeCard.leadingAnchor, constant: Layout.Padding.card),
            insuranceRow.trailingAnchor.constraint(equalTo: administrativeCard.trailingAnchor, constant: -Layout.Padding.card),
            
            emergencyRow.topAnchor.constraint(equalTo: insuranceRow.bottomAnchor, constant: Layout.Spacing.md),
            emergencyRow.leadingAnchor.constraint(equalTo: administrativeCard.leadingAnchor, constant: Layout.Padding.card),
            emergencyRow.trailingAnchor.constraint(equalTo: administrativeCard.trailingAnchor, constant: -Layout.Padding.card),
            emergencyRow.bottomAnchor.constraint(equalTo: administrativeCard.bottomAnchor, constant: -Layout.Padding.card)
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.Spacing.xl),
            avatarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Layout.Spacing.lg),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            
            infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Layout.Spacing.xs),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            
            statsStackView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: Layout.Spacing.xxl),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            
            medicalDetailsSection.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: Layout.Spacing.lg),
            medicalDetailsSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            medicalDetailsSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            
            medicalCard.topAnchor.constraint(equalTo: medicalDetailsSection.bottomAnchor, constant: Layout.Spacing.sm),
            medicalCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            medicalCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            
            administrativeSection.topAnchor.constraint(equalTo: medicalCard.bottomAnchor, constant: Layout.Spacing.lg),
            administrativeSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            administrativeSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            
            administrativeCard.topAnchor.constraint(equalTo: administrativeSection.bottomAnchor, constant: Layout.Spacing.sm),
            administrativeCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            administrativeCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            administrativeCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.Spacing.xxl)
        ])
    }
    
    private func populateData() {
        avatarView.setImage(AppAssets.Icons.personCircle)
        avatarView.setOnlineStatus(true)
    }
    
    // MARK: - Dynamic Update Methods
    
    private var bloodView: IconLabelView?
    private var heightView: IconLabelView?
    private var weightView: IconLabelView?
    
    private func updateStatsViews(blood: String, height: String, weight: String) {
        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        bloodView = IconLabelView(icon: AppAssets.Icons.drop, iconColor: AppColors.bloodType, title: "BLOOD", value: blood)
        heightView = IconLabelView(icon: AppAssets.Icons.ruler, iconColor: AppColors.height, title: "HEIGHT", value: height)
        weightView = IconLabelView(icon: AppAssets.Icons.scalemass, iconColor: AppColors.weight, title: "WEIGHT", value: weight)
        
        if let bloodView = bloodView, let heightView = heightView, let weightView = weightView {
            statsStackView.addArrangedSubview(bloodView)
            statsStackView.addArrangedSubview(heightView)
            statsStackView.addArrangedSubview(weightView)
        }
    }
    
    private var allergiesRow: InfoRowView?
    private var conditionsRow: InfoRowView?
    private var medicationsRow: InfoRowView?
    
    private func updateMedicalCard(allergies: String, conditions: String, medications: String) {
        medicalCard.subviews.forEach { $0.removeFromSuperview() }
        
        allergiesRow = InfoRowView(
            icon: AppAssets.Icons.exclamationTriangle,
            iconColor: AppColors.error,
            title: "Allergies",
            subtitle: allergies,
            showChevron: true
        )
        
        conditionsRow = InfoRowView(
            icon: AppAssets.Icons.cross,
            iconColor: AppColors.info,
            title: "Chronic Conditions",
            subtitle: conditions,
            showChevron: true
        )
        
        medicationsRow = InfoRowView(
            icon: AppAssets.Icons.pills,
            iconColor: AppColors.warning,
            title: "Current Medications",
            subtitle: medications,
            showChevron: true
        )
        
        guard let allergiesRow = allergiesRow,
              let conditionsRow = conditionsRow,
              let medicationsRow = medicationsRow else { return }
        
        allergiesRow.translatesAutoresizingMaskIntoConstraints = false
        conditionsRow.translatesAutoresizingMaskIntoConstraints = false
        medicationsRow.translatesAutoresizingMaskIntoConstraints = false
        
        medicalCard.addSubview(allergiesRow)
        medicalCard.addSubview(conditionsRow)
        medicalCard.addSubview(medicationsRow)
        
        NSLayoutConstraint.activate([
            allergiesRow.topAnchor.constraint(equalTo: medicalCard.topAnchor, constant: Layout.Padding.card),
            allergiesRow.leadingAnchor.constraint(equalTo: medicalCard.leadingAnchor, constant: Layout.Padding.card),
            allergiesRow.trailingAnchor.constraint(equalTo: medicalCard.trailingAnchor, constant: -Layout.Padding.card),
            
            conditionsRow.topAnchor.constraint(equalTo: allergiesRow.bottomAnchor, constant: Layout.Spacing.md),
            conditionsRow.leadingAnchor.constraint(equalTo: medicalCard.leadingAnchor, constant: Layout.Padding.card),
            conditionsRow.trailingAnchor.constraint(equalTo: medicalCard.trailingAnchor, constant: -Layout.Padding.card),
            
            medicationsRow.topAnchor.constraint(equalTo: conditionsRow.bottomAnchor, constant: Layout.Spacing.md),
            medicationsRow.leadingAnchor.constraint(equalTo: medicalCard.leadingAnchor, constant: Layout.Padding.card),
            medicationsRow.trailingAnchor.constraint(equalTo: medicalCard.trailingAnchor, constant: -Layout.Padding.card),
            medicationsRow.bottomAnchor.constraint(equalTo: medicalCard.bottomAnchor, constant: -Layout.Padding.card)
        ])
    }
    
    private var insuranceRow: InfoRowView?
    private var emergencyRow: InfoRowView?
    
    private func updateAdministrativeCard(insurance: String, emergency: String) {
        administrativeCard.subviews.forEach { $0.removeFromSuperview() }
        
        insuranceRow = InfoRowView(
            icon: AppAssets.Icons.shield,
            iconColor: AppColors.secondary,
            title: "Insurance",
            subtitle: insurance,
            showChevron: true
        )
        
        emergencyRow = InfoRowView(
            icon: AppAssets.Icons.phoneCircle,
            iconColor: AppColors.success,
            title: "Emergency Contact",
            subtitle: emergency,
            showChevron: true
        )
        
        guard let insuranceRow = insuranceRow, let emergencyRow = emergencyRow else { return }
        
        insuranceRow.translatesAutoresizingMaskIntoConstraints = false
        emergencyRow.translatesAutoresizingMaskIntoConstraints = false
        
        administrativeCard.addSubview(insuranceRow)
        administrativeCard.addSubview(emergencyRow)
        
        NSLayoutConstraint.activate([
            insuranceRow.topAnchor.constraint(equalTo: administrativeCard.topAnchor, constant: Layout.Padding.card),
            insuranceRow.leadingAnchor.constraint(equalTo: administrativeCard.leadingAnchor, constant: Layout.Padding.card),
            insuranceRow.trailingAnchor.constraint(equalTo: administrativeCard.trailingAnchor, constant: -Layout.Padding.card),
            
            emergencyRow.topAnchor.constraint(equalTo: insuranceRow.bottomAnchor, constant: Layout.Spacing.md),
            emergencyRow.leadingAnchor.constraint(equalTo: administrativeCard.leadingAnchor, constant: Layout.Padding.card),
            emergencyRow.trailingAnchor.constraint(equalTo: administrativeCard.trailingAnchor, constant: -Layout.Padding.card),
            emergencyRow.bottomAnchor.constraint(equalTo: administrativeCard.bottomAnchor, constant: -Layout.Padding.card)
        ])
    }
}
