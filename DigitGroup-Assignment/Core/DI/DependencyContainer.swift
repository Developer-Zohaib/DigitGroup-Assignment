//
//  DependencyContainer.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit

protocol DependencyContainerProtocol {
    func makePatientProfileViewModel() -> PatientProfileViewModel
    func makeAppointmentsViewModel() -> AppointmentsViewModel
    func makeAppointmentDetailViewModel(appointmentId: String) -> AppointmentDetailViewModel
    func makeVitalsViewModel() -> VitalsViewModel
}

final class DependencyContainer: DependencyContainerProtocol {
    
    // MARK: - Shared Patient ID (in real app, this would come from auth)
    
    private let currentPatientId = "patient-001"
    
    // MARK: - Data Sources (Lazy initialization)
    
    private lazy var patientDataSource: PatientDataSourceProtocol = {
        MockPatientDataSource()
    }()
    
    private lazy var appointmentDataSource: AppointmentDataSourceProtocol = {
        MockAppointmentDataSource()
    }()
    
    private lazy var vitalDataSource: VitalDataSourceProtocol = {
        MockVitalDataSource()
    }()
    
    // MARK: - Repositories
    
    private lazy var patientRepository: PatientRepositoryProtocol = {
        PatientRepository(dataSource: patientDataSource)
    }()
    
    private lazy var appointmentRepository: AppointmentRepositoryProtocol = {
        AppointmentRepository(dataSource: appointmentDataSource)
    }()
    
    private lazy var vitalRepository: VitalRepositoryProtocol = {
        VitalRepository(dataSource: vitalDataSource)
    }()
    
    // MARK: - Use Cases
    
    private func makeFetchPatientProfileUseCase() -> FetchPatientProfileUseCaseProtocol {
        FetchPatientProfileUseCase(repository: patientRepository)
    }
    
    private func makeFetchAppointmentsUseCase() -> FetchAppointmentsUseCaseProtocol {
        FetchAppointmentsUseCase(repository: appointmentRepository)
    }
    
    private func makeFetchAppointmentDetailUseCase() -> FetchAppointmentDetailUseCaseProtocol {
        FetchAppointmentDetailUseCase(repository: appointmentRepository)
    }
    
    private func makeFetchVitalsUseCase() -> FetchVitalsUseCaseProtocol {
        FetchVitalsUseCase(repository: vitalRepository)
    }
    
    // MARK: - ViewModels
    
    func makePatientProfileViewModel() -> PatientProfileViewModel {
        PatientProfileViewModel(fetchPatientUseCase: makeFetchPatientProfileUseCase())
    }
    
    func makeAppointmentsViewModel() -> AppointmentsViewModel {
        AppointmentsViewModel(
            fetchAppointmentsUseCase: makeFetchAppointmentsUseCase(),
            patientId: currentPatientId
        )
    }
    
    func makeAppointmentDetailViewModel(appointmentId: String) -> AppointmentDetailViewModel {
        AppointmentDetailViewModel(
            fetchAppointmentUseCase: makeFetchAppointmentDetailUseCase(),
            appointmentId: appointmentId
        )
    }
    
    func makeVitalsViewModel() -> VitalsViewModel {
        VitalsViewModel(
            fetchVitalsUseCase: makeFetchVitalsUseCase(),
            patientId: currentPatientId
        )
    }
}

// MARK: - Factory for Coordinators

extension DependencyContainer {
    
    func makeAppCoordinator(navigationController: UINavigationController) -> AppCoordinator {
        AppCoordinator(navigationController: navigationController, dependencyContainer: self)
    }
}
