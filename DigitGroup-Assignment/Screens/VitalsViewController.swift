//
//  VitalsViewController.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit
import Combine

class VitalsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: VitalsViewModelProtocol?
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
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Vitals"
        label.font = AppFonts.largeTitle(weight: .bold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Today, Oct 24"
        label.font = AppFonts.subheadline()
        label.textColor = AppColors.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)        
        button.setImage(AppAssets.Icons.plus, for: .normal)
        button.tintColor = AppColors.primary
        button.backgroundColor = AppColors.primary.withAlphaComponent(0.1)
        button.layer.cornerRadius = Layout.CornerRadius.sm
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let vitalsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Layout.Spacing.md
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let infoCard = CardView()
    
    // MARK: - Configuration
    
    func configure(with viewModel: VitalsViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        populateVitals()
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
    
    private func handleState(_ state: VitalsViewModel.State) {
        switch state {
        case .idle, .loading:
            break
        case .loaded(let data):
            dateLabel.text = data.dateFormatted
        case .empty(let message):
            break
        case .error(let message):
            showError(message)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        
        infoCard.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(dateLabel)
        headerView.addSubview(addButton)
        
        contentView.addSubview(vitalsStackView)
        contentView.addSubview(infoCard)
        
        setupInfoCard()
    }
    
    private func setupInfoCard() {
        let iconImageView: UIImageView = {
            let iv = UIImageView()
            iv.image = AppAssets.Icons.info
            iv.tintColor = AppColors.info
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = "Your vitals are trending normally this week. Tap on any card to see detailed history and charts."
            label.font = AppFonts.footnote()
            label.textColor = AppColors.textSecondary
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        infoCard.backgroundColor = AppColors.info.withAlphaComponent(0.1)
        infoCard.addSubview(iconImageView)
        infoCard.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: Layout.Padding.card),
            iconImageView.topAnchor.constraint(equalTo: infoCard.topAnchor, constant: Layout.Padding.card),
            iconImageView.widthAnchor.constraint(equalToConstant: Layout.IconSize.sm),
            iconImageView.heightAnchor.constraint(equalToConstant: Layout.IconSize.sm),
            
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Layout.Spacing.sm),
            messageLabel.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -Layout.Padding.card),
            messageLabel.topAnchor.constraint(equalTo: infoCard.topAnchor, constant: Layout.Padding.card),
            messageLabel.bottomAnchor.constraint(equalTo: infoCard.bottomAnchor, constant: -Layout.Padding.card)
        ])
    }
    
    private func populateVitals() {
        let vitals: [(UIImage?, String, String, String, String, UIColor)] = [
            (AppAssets.Icons.heartFill, "Heart Rate", "Normal • 10:30 AM", "72", "bpm", AppColors.heartRate),
            (AppAssets.Icons.stethoscope, "Blood Pressure", "Normal • 10:30 AM", "120/80", "mmHg", AppColors.bloodPressure),
            (AppAssets.Icons.thermometer, "Temperature", "Normal • 08:15 AM", "98.6", "°F", AppColors.temperature),
            (AppAssets.Icons.lungs, "Oxygen Level", "Normal • 10:30 AM", "98", "%", AppColors.oxygen),
            (AppAssets.Icons.respiratory, "Respiratory Rate", "Normal • 10:30 AM", "16", "br/min", AppColors.respiratory)
        ]
        
        for vital in vitals {
            let card = createVitalCard(icon: vital.0, title: vital.1, status: vital.2, value: vital.3, unit: vital.4, color: vital.5)
            vitalsStackView.addArrangedSubview(card)
        }
    }
    
    private func createVitalCard(icon: UIImage?, title: String, status: String, value: String, unit: String, color: UIColor) -> CardView {
        let card = CardView()
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let iconContainer: UIView = {
            let view = UIView()
            view.backgroundColor = color.withAlphaComponent(0.1)
            view.layer.cornerRadius = Layout.CornerRadius.sm
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let iconImageView: UIImageView = {
            let iv = UIImageView()
            iv.image = icon
            iv.tintColor = color
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = title
            label.font = AppFonts.headline(weight: .semibold)
            label.textColor = AppColors.textPrimary
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let statusLabel: UILabel = {
            let label = UILabel()
            label.text = status
            label.font = AppFonts.caption1()
            label.textColor = AppColors.textSecondary
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let statusDot: UIView = {
            let view = UIView()
            view.backgroundColor = AppColors.success
            view.layer.cornerRadius = 3
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let valueLabel: UILabel = {
            let label = UILabel()
            label.text = value
            label.font = AppFonts.title1(weight: .bold)
            label.textColor = AppColors.textPrimary
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let unitLabel: UILabel = {
            let label = UILabel()
            label.text = unit
            label.font = AppFonts.subheadline()
            label.textColor = AppColors.textSecondary
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        iconContainer.addSubview(iconImageView)
        card.addSubview(iconContainer)
        card.addSubview(titleLabel)
        card.addSubview(statusDot)
        card.addSubview(statusLabel)
        card.addSubview(valueLabel)
        card.addSubview(unitLabel)
        
        NSLayoutConstraint.activate([
            iconContainer.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: Layout.Padding.card),
            iconContainer.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: Layout.IconSize.xl + 8),
            iconContainer.heightAnchor.constraint(equalToConstant: Layout.IconSize.xl + 8),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: Layout.IconSize.md),
            iconImageView.heightAnchor.constraint(equalToConstant: Layout.IconSize.md),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: Layout.Spacing.md),
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: Layout.Padding.card),
            
            statusDot.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            statusDot.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Layout.Spacing.sm),
            statusDot.widthAnchor.constraint(equalToConstant: 6),
            statusDot.heightAnchor.constraint(equalToConstant: 6),
            statusDot.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -Layout.Padding.card),
            
            statusLabel.leadingAnchor.constraint(equalTo: statusDot.trailingAnchor, constant: Layout.Spacing.xs),
            statusLabel.centerYAnchor.constraint(equalTo: statusDot.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: unitLabel.leadingAnchor, constant: -Layout.Spacing.xs),
            valueLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            
            unitLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -Layout.Padding.card),
            unitLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        
        return card
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
            
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: Layout.Spacing.md),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Layout.Spacing.xs),
            dateLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            addButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 40),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            
            vitalsStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Layout.Spacing.xl),
            vitalsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            vitalsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            
            infoCard.topAnchor.constraint(equalTo: vitalsStackView.bottomAnchor, constant: Layout.Spacing.lg),
            infoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            infoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            infoCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.Spacing.xxl)
        ])
    }
}
