//
//  AppointmentsViewController.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit
import Combine

struct Appointment {
    let doctorName: String
    let specialty: String
    let time: String
    let timeColor: UIColor
    let location: String
    let showVideoIcon: Bool
    let showOnline: Bool
}

class AppointmentsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: AppointmentsViewModelProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    private enum Section: Int, CaseIterable {
        case today = 0
        case nextWeek = 1
    }
    
    private var upcomingAppointments: [[Appointment]] = [[], []]
    private var pastAppointments: [[Appointment]] = [[], []]
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Appointments"
        label.font = AppFonts.largeTitle(weight: .bold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let calendarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(AppAssets.Icons.calendarSystem, for: .normal)
        button.tintColor = AppColors.primary
        button.backgroundColor = AppColors.primary.withAlphaComponent(0.1)
        button.layer.cornerRadius = Layout.CornerRadius.sm
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["Upcoming", "Past"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let emptyStateImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = AppAssets.Icons.calendarSystem
        iv.tintColor = AppColors.textTertiary
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let emptyStateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "No Past Appointments"
        label.font = AppFonts.headline(weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptyStateSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your completed appointments will appear here"
        label.font = AppFonts.subheadline()
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fabButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(AppAssets.Icons.plus, for: .normal)
        button.tintColor = .white
        button.backgroundColor = AppColors.primary
        button.layer.cornerRadius = 28
        let shadow = Layout.Shadow.elevated()
        button.layer.shadowColor = shadow.color.cgColor
        button.layer.shadowOpacity = shadow.opacity
        button.layer.shadowOffset = shadow.offset
        button.layer.shadowRadius = shadow.radius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Configuration
    
    func configure(with viewModel: AppointmentsViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
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
    
    private func handleState(_ state: AppointmentsViewModel.State) {
        switch state {
        case .idle, .loading:
            break
        case .loaded(let data):
            updateUI(with: data)
        case .empty(let message):
            showEmptyState(message: message)
        case .error(let message):
            showError(message)
        }
    }
    
    private func updateUI(with data: AppointmentsViewModel.SegmentData) {
        tableView.reloadData()
    }
    
    private func showEmptyState(message: String) {
        emptyStateTitleLabel.text = message
        tableView.isHidden = true
        emptyStateView.isHidden = false
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupData() {
        upcomingAppointments[Section.today.rawValue] = [
            Appointment(
                doctorName: "Dr. Sarah Johnson",
                specialty: "Cardiology",
                time: "10:00 AM",
                timeColor: AppColors.primary,
                location: "Video Consultation",
                showVideoIcon: true,
                showOnline: true
            ),
            Appointment(
                doctorName: "Dr. Mark Lee",
                specialty: "Dermatology",
                time: "2:30 PM",
                timeColor: AppColors.primary,
                location: "City General Hospital, Room 304",
                showVideoIcon: false,
                showOnline: false
            )
        ]
        
        upcomingAppointments[Section.nextWeek.rawValue] = [
            Appointment(
                doctorName: "Dr. Emily Chen",
                specialty: "Orthopedics",
                time: "Mon, 9:00 AM",
                timeColor: AppColors.textSecondary,
                location: "Sports Medicine Center, Building A",
                showVideoIcon: false,
                showOnline: false
            )
        ]
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(calendarButton)
        
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(fabButton)
        
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateTitleLabel)
        emptyStateView.addSubview(emptyStateSubtitleLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AppointmentTableViewCell.self, forCellReuseIdentifier: AppointmentTableViewCell.identifier)
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged() {
        let isUpcoming = segmentedControl.selectedSegmentIndex == 0
        tableView.isHidden = !isUpcoming
        emptyStateView.isHidden = isUpcoming
        
        if isUpcoming {
            tableView.reloadData()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.Padding.screen),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.Padding.screen),
            
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: Layout.Spacing.md),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            calendarButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            calendarButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            calendarButton.widthAnchor.constraint(equalToConstant: 40),
            calendarButton.heightAnchor.constraint(equalToConstant: 40),
            
            segmentedControl.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Layout.Spacing.xl),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.Padding.screen),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.Padding.screen),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Layout.Spacing.md),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.Padding.screen),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.Padding.screen),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 100),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.Padding.screen),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.Padding.screen),
            
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 60),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 60),
            
            emptyStateTitleLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: Layout.Spacing.lg),
            emptyStateTitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateTitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            emptyStateSubtitleLabel.topAnchor.constraint(equalTo: emptyStateTitleLabel.bottomAnchor, constant: Layout.Spacing.sm),
            emptyStateSubtitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateSubtitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptyStateSubtitleLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor),
            
            fabButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.Padding.screen),
            fabButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            fabButton.widthAnchor.constraint(equalToConstant: 56),
            fabButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func currentAppointments() -> [[Appointment]] {
        return segmentedControl.selectedSegmentIndex == 0 ? upcomingAppointments : pastAppointments
    }
    
    private func sectionTitle(for section: Int) -> String {
        guard let sectionType = Section(rawValue: section) else { return "" }
        switch sectionType {
        case .today: return "Today"
        case .nextWeek: return "Next Week"
        }
    }
}

extension AppointmentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAppointments()[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppointmentTableViewCell.identifier, for: indexPath) as? AppointmentTableViewCell else {
            return UITableViewCell()
        }
        
        let appointment = currentAppointments()[indexPath.section][indexPath.row]
        cell.configure(
            doctorName: appointment.doctorName,
            specialty: appointment.specialty,
            time: appointment.time,
            timeColor: appointment.timeColor,
            location: appointment.location,
            showVideoIcon: appointment.showVideoIcon,
            showOnline: appointment.showOnline
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard currentAppointments()[section].count > 0 else { return nil }
        
        let container = UIView()
        container.backgroundColor = AppColors.background
        
        let titleLabel = UILabel()
        titleLabel.text = sectionTitle(for: section)
        titleLabel.font = AppFonts.footnote(weight: .semibold)
        titleLabel.textColor = AppColors.textSecondary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Layout.Spacing.sm)
        ])
        
        return container
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return currentAppointments()[section].count > 0 ? 44 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = AppointmentDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
