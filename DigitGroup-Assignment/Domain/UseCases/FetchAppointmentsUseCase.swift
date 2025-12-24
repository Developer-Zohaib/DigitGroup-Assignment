//
//  FetchAppointmentsUseCase.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

protocol FetchAppointmentsUseCaseProtocol {
    func execute(patientId: String) -> AnyPublisher<[AppointmentEntity], Error>
    func executeUpcoming(patientId: String) -> AnyPublisher<[AppointmentEntity], Error>
    func executePast(patientId: String) -> AnyPublisher<[AppointmentEntity], Error>
}

final class FetchAppointmentsUseCase: FetchAppointmentsUseCaseProtocol {
    
    private let repository: AppointmentRepositoryProtocol
    
    init(repository: AppointmentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        return repository.fetchAppointments(for: patientId)
    }
    
    func executeUpcoming(patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        return repository.fetchUpcomingAppointments(for: patientId)
    }
    
    func executePast(patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        return repository.fetchPastAppointments(for: patientId)
    }
}

protocol FetchAppointmentDetailUseCaseProtocol {
    func execute(appointmentId: String) -> AnyPublisher<AppointmentEntity, Error>
}

final class FetchAppointmentDetailUseCase: FetchAppointmentDetailUseCaseProtocol {
    
    private let repository: AppointmentRepositoryProtocol
    
    init(repository: AppointmentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(appointmentId: String) -> AnyPublisher<AppointmentEntity, Error> {
        return repository.fetchAppointment(id: appointmentId)
    }
}
