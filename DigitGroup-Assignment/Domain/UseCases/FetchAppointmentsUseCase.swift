//
//  FetchAppointmentsUseCase.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

// MARK: - Fetch Appointments Use Case

protocol FetchAppointmentsUseCaseProtocol {
    func execute(patientId: String) -> AnyPublisher<[AppointmentEntity], Error>
    func executeUpcoming(patientId: String) -> AnyPublisher<[AppointmentEntity], Error>
    func executePast(patientId: String) -> AnyPublisher<[AppointmentEntity], Error>
}

/// Fetches appointments with optional filtering (all/upcoming/past)
final class FetchAppointmentsUseCase: FetchAppointmentsUseCaseProtocol {
    private let repository: AppointmentRepositoryProtocol
    
    init(repository: AppointmentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        repository.fetchAppointments(for: patientId)
    }
    
    func executeUpcoming(patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        repository.fetchUpcomingAppointments(for: patientId)
    }
    
    func executePast(patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        repository.fetchPastAppointments(for: patientId)
    }
}

// MARK: - Fetch Appointment Detail Use Case

protocol FetchAppointmentDetailUseCaseProtocol {
    func execute(appointmentId: String) -> AnyPublisher<AppointmentEntity, Error>
}

/// Fetches single appointment by ID
final class FetchAppointmentDetailUseCase: FetchAppointmentDetailUseCaseProtocol {
    private let repository: AppointmentRepositoryProtocol
    
    init(repository: AppointmentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(appointmentId: String) -> AnyPublisher<AppointmentEntity, Error> {
        repository.fetchAppointment(id: appointmentId)
    }
}
