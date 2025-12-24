//
//  PatientFlowCoordinator.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit
import Combine

final class PatientFlowCoordinator: Coordinator {
    
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
        showPatientProfile()
    }
    
    private func showPatientProfile() {
        let viewModel = dependencyContainer.makePatientProfileViewModel()
        let viewController = PatientProfileViewController()
        viewController.configure(with: viewModel)
        
        viewModel.navigationEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handleNavigationEvent(event)
            }
            .store(in: &cancellables)
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    private func handleNavigationEvent(_ event: PatientProfileViewModel.NavigationEvent) {
        switch event {
        case .showAppointments:
            showAppointments()
        case .showVitals:
            showVitals()
        case .showAllergyDetail(let allergies):
            showAllergyDetail(allergies)
        case .showConditionDetail(let conditions):
            showConditionDetail(conditions)
        case .showMedicationDetail(let medications):
            showMedicationDetail(medications)
        case .showInsuranceDetail(let insurance):
            showInsuranceDetail(insurance)
        case .showEmergencyContactDetail(let contact):
            showEmergencyContactDetail(contact)
        }
    }
    
    private func showAppointments() {
        let appointmentsCoordinator = AppointmentsCoordinator(
            navigationController: navigationController,
            dependencyContainer: dependencyContainer
        )
        addChild(appointmentsCoordinator)
        appointmentsCoordinator.startPushed()
    }
    
    private func showVitals() {
        let vitalsCoordinator = VitalsCoordinator(
            navigationController: navigationController,
            dependencyContainer: dependencyContainer
        )
        addChild(vitalsCoordinator)
        vitalsCoordinator.startPushed()
    }
    
    private func showAllergyDetail(_ allergies: [String]) {
        // Placeholder for allergy detail screen
    }
    
    private func showConditionDetail(_ conditions: [String]) {
        // Placeholder for condition detail screen
    }
    
    private func showMedicationDetail(_ medications: [Medication]) {
        // Placeholder for medication detail screen
    }
    
    private func showInsuranceDetail(_ insurance: Insurance) {
        // Placeholder for insurance detail screen
    }
    
    private func showEmergencyContactDetail(_ contact: EmergencyContact) {
        // Placeholder for emergency contact detail screen
    }
}
