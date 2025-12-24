//
//  AppointmentsCoordinator.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit
import Combine

final class AppointmentsCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    
    private let dependencyContainer: DependencyContainerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController, dependencyContainer: DependencyContainerProtocol) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        showAppointmentsList(animated: false)
    }
    
    func startPushed() {
        showAppointmentsList(animated: true)
    }
    
    private func showAppointmentsList(animated: Bool) {
        let viewModel = dependencyContainer.makeAppointmentsViewModel()
        let viewController = AppointmentsViewController()
        viewController.configure(with: viewModel)
        
        viewModel.navigationEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handleNavigationEvent(event)
            }
            .store(in: &cancellables)
        
        if animated {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            navigationController.setViewControllers([viewController], animated: false)
        }
    }
    
    private func handleNavigationEvent(_ event: AppointmentsViewModel.NavigationEvent) {
        switch event {
        case .showAppointmentDetail(let appointmentId):
            showAppointmentDetail(appointmentId: appointmentId)
        case .showAddAppointment:
            showAddAppointment()
        }
    }
    
    private func showAppointmentDetail(appointmentId: String) {
        let viewModel = dependencyContainer.makeAppointmentDetailViewModel(appointmentId: appointmentId)
        let viewController = AppointmentDetailViewController()
        viewController.configure(with: viewModel)
        
        viewModel.navigationEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handleDetailNavigationEvent(event)
            }
            .store(in: &cancellables)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleDetailNavigationEvent(_ event: AppointmentDetailViewModel.NavigationEvent) {
        switch event {
        case .dismiss:
            navigationController.popViewController(animated: true)
        case .openMaps(let latitude, let longitude):
            openMaps(latitude: latitude, longitude: longitude)
        case .joinVideoCall(let appointmentId):
            joinVideoCall(appointmentId: appointmentId)
        case .showReschedule(let appointmentId):
            showReschedule(appointmentId: appointmentId)
        case .showCancelConfirmation(let appointmentId):
            showCancelConfirmation(appointmentId: appointmentId)
        }
    }
    
    private func showAddAppointment() {
        // Placeholder for add appointment flow
    }
    
    private func openMaps(latitude: Double, longitude: Double) {
        let url = URL(string: "maps://?daddr=\(latitude),\(longitude)")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func joinVideoCall(appointmentId: String) {
        // Placeholder for video call integration
    }
    
    private func showReschedule(appointmentId: String) {
        // Placeholder for reschedule flow
    }
    
    private func showCancelConfirmation(appointmentId: String) {
        let alert = UIAlertController(
            title: "Cancel Appointment",
            message: "Are you sure you want to cancel this appointment?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes, Cancel", style: .destructive) { _ in
            // Handle cancellation
        })
        navigationController.present(alert, animated: true)
    }
}
