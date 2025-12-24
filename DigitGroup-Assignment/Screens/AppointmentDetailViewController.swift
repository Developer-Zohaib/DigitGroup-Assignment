//
//  AppointmentDetailViewController.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit
import MapKit
import Combine

class AppointmentDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: AppointmentDetailViewModelProtocol?
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
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(AppAssets.Icons.leftArrow, for: .normal)
        button.tintColor = AppColors.primary
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Appointment Details"
        label.font = AppFonts.headline(weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let avatarView = AvatarImageView(size: Layout.AvatarSize.xl, showOnlineIndicator: true)
    
    private let doctorNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Dr. Sarah Jenning"
        label.font = AppFonts.title2(weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let specialtyLabel: UILabel = {
        let label = UILabel()
        label.text = "Cardiologist"
        label.font = AppFonts.subheadline()
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusBadge = BadgeView(
        text: "CONFIRMED",
        backgroundColor: AppColors.statusConfirmed.withAlphaComponent(0.1),
        textColor: AppColors.statusConfirmed
    )
    
    private let dateCard = CardView()
    private let timeCard = CardView()
    private let locationCard = CardView()
    
    private let locationHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = AppFonts.headline(weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let directionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Directions", for: .normal)
        button.setTitleColor(AppColors.primary, for: .normal)
        button.titleLabel?.font = AppFonts.subheadline(weight: .semibold)
        button.setImage(AppAssets.Icons.arrowRight, for: .normal)
        button.tintColor = AppColors.primary
        button.semanticContentAttribute = .forceRightToLeft
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = Layout.CornerRadius.md
        map.clipsToBounds = true
        map.isScrollEnabled = false
        map.isZoomEnabled = false
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let addressCard = CardView()
    
    // MARK: - Configuration
    
    func configure(with viewModel: AppointmentDetailViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        populateData()
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
    
    private func handleState(_ state: AppointmentDetailViewModel.State) {
        switch state {
        case .idle, .loading:
            break
        case .loaded(let data):
            updateUI(with: data)
        case .error(let message):
            showError(message)
        }
    }
    
    private func updateUI(with data: AppointmentDetailViewModel.AppointmentDetail) {
        doctorNameLabel.text = data.doctorName
        specialtyLabel.text = data.specialty
        
        if let lat = data.latitude, let lon = data.longitude {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: false)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = data.locationName
            mapView.addAnnotation(annotation)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        statusBadge.translatesAutoresizingMaskIntoConstraints = false
        dateCard.translatesAutoresizingMaskIntoConstraints = false
        timeCard.translatesAutoresizingMaskIntoConstraints = false
        locationCard.translatesAutoresizingMaskIntoConstraints = false
        addressCard.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        view.addSubview(headerLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(avatarView)
        contentView.addSubview(doctorNameLabel)
        contentView.addSubview(specialtyLabel)
        contentView.addSubview(statusBadge)
        contentView.addSubview(dateCard)
        contentView.addSubview(timeCard)
        contentView.addSubview(locationHeaderLabel)
        contentView.addSubview(directionsButton)
        contentView.addSubview(mapView)
        contentView.addSubview(addressCard)
        
        setupDateCard()
        setupTimeCard()
        setupAddressCard()
    }
    
    private func setupDateCard() {
        let iconView: UIImageView = {
            let iv = UIImageView()
            iv.image = AppAssets.Icons.calendar
            iv.tintColor = AppColors.primary
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "DATE"
            label.font = AppFonts.caption1(weight: .semibold)
            label.textColor = AppColors.textSecondary
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let dateLabel: UILabel = {
            let label = UILabel()
            label.text = "Monday, Oct 24, 2023"
            label.font = AppFonts.headline(weight: .semibold)
            label.textColor = AppColors.textPrimary
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        dateCard.addSubview(iconView)
        dateCard.addSubview(titleLabel)
        dateCard.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: dateCard.leadingAnchor, constant: Layout.Padding.card),
            iconView.centerYAnchor.constraint(equalTo: dateCard.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: Layout.IconSize.md),
            iconView.heightAnchor.constraint(equalToConstant: Layout.IconSize.md),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Layout.Padding.card),
            titleLabel.topAnchor.constraint(equalTo: dateCard.topAnchor, constant: Layout.Padding.card),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Layout.Spacing.xs),
            dateLabel.bottomAnchor.constraint(equalTo: dateCard.bottomAnchor, constant: -Layout.Padding.card)
        ])
    }
    
    private func setupTimeCard() {
        let iconView: UIImageView = {
            let iv = UIImageView()
            iv.image = AppAssets.Icons.clock
            iv.tintColor = AppColors.primary
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "TIME"
            label.font = AppFonts.caption1(weight: .semibold)
            label.textColor = AppColors.textSecondary
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let timeLabel: UILabel = {
            let label = UILabel()
            label.text = "10:00 AM - 10:30 AM"
            label.font = AppFonts.headline(weight: .semibold)
            label.textColor = AppColors.textPrimary
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        timeCard.addSubview(iconView)
        timeCard.addSubview(titleLabel)
        timeCard.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: timeCard.leadingAnchor, constant: Layout.Padding.card),
            iconView.centerYAnchor.constraint(equalTo: timeCard.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: Layout.IconSize.md),
            iconView.heightAnchor.constraint(equalToConstant: Layout.IconSize.md),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Layout.Padding.card),
            titleLabel.topAnchor.constraint(equalTo: timeCard.topAnchor, constant: Layout.Padding.card),
            
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Layout.Spacing.xs),
            timeLabel.bottomAnchor.constraint(equalTo: timeCard.bottomAnchor, constant: -Layout.Padding.card)
        ])
    }
    
    private func setupAddressCard() {
        let iconView: UIImageView = {
            let iv = UIImageView()
            iv.image = AppAssets.Icons.hospital
            iv.tintColor = AppColors.primary
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.text = "Heart Care Center, Room 302"
            label.font = AppFonts.headline(weight: .semibold)
            label.textColor = AppColors.textPrimary
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let addressLabel: UILabel = {
            let label = UILabel()
            label.text = "123 Wellness Blvd, New York, NY"
            label.font = AppFonts.subheadline()
            label.textColor = AppColors.textSecondary
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        addressCard.addSubview(iconView)
        addressCard.addSubview(nameLabel)
        addressCard.addSubview(addressLabel)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: addressCard.leadingAnchor, constant: Layout.Padding.card),
            iconView.centerYAnchor.constraint(equalTo: addressCard.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: Layout.IconSize.md),
            iconView.heightAnchor.constraint(equalToConstant: Layout.IconSize.md),

            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Layout.Spacing.md),
            nameLabel.topAnchor.constraint(equalTo: addressCard.topAnchor, constant: Layout.Padding.card),
            
            addressLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Layout.Spacing.xs),
            addressLabel.bottomAnchor.constraint(equalTo: addressCard.bottomAnchor, constant: -Layout.Padding.card)
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.Padding.screen),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.Spacing.sm),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: Layout.Spacing.lg),
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
            
            doctorNameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Layout.Spacing.lg),
            doctorNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            doctorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            
            specialtyLabel.topAnchor.constraint(equalTo: doctorNameLabel.bottomAnchor, constant: Layout.Spacing.xs),
            specialtyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            specialtyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            
            statusBadge.topAnchor.constraint(equalTo: specialtyLabel.bottomAnchor, constant: Layout.Spacing.md),
            statusBadge.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            dateCard.topAnchor.constraint(equalTo: statusBadge.bottomAnchor, constant: Layout.Spacing.xxl),
            dateCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            dateCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            
            timeCard.topAnchor.constraint(equalTo: dateCard.bottomAnchor, constant: Layout.Spacing.md),
            timeCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            timeCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            
            locationHeaderLabel.topAnchor.constraint(equalTo: timeCard.bottomAnchor, constant: Layout.Spacing.xxl),
            locationHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            
            directionsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            directionsButton.centerYAnchor.constraint(equalTo: locationHeaderLabel.centerYAnchor),
            
            mapView.topAnchor.constraint(equalTo: locationHeaderLabel.bottomAnchor, constant: Layout.Spacing.md),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            mapView.heightAnchor.constraint(equalToConstant: 180),
            
            addressCard.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: Layout.Spacing.md),
            addressCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Padding.screen),
            addressCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Padding.screen),
            addressCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.Spacing.xxl)
        ])
    }
    
    private func populateData() {
        avatarView.setImage(AppAssets.Icons.personCircle)
        avatarView.setOnlineStatus(true)
        setupMapLocation()
    }
    
    private func setupMapLocation() {
        let coordinate = CLLocationCoordinate2D(latitude: 40.7580, longitude: -73.9855)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Heart Care Center"
        annotation.subtitle = "Room 302"
        
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: false)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
