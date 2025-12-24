//
//  AppointmentRepository.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

/// Appointment repository with filtering and sorting logic
final class AppointmentRepository: AppointmentRepositoryProtocol {
    private let dataSource: AppointmentDataSourceProtocol
    
    init(dataSource: AppointmentDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchAppointments(for patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        dataSource.fetchAppointments(for: patientId)
    }
    
    /// Returns upcoming appointments sorted by date (earliest first)
    func fetchUpcomingAppointments(for patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        dataSource.fetchAppointments(for: patientId)
            .map { $0.filter { $0.isUpcoming }.sorted { $0.scheduledDate < $1.scheduledDate } }
            .eraseToAnyPublisher()
    }
    
    /// Returns past appointments sorted by date (most recent first)
    func fetchPastAppointments(for patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        dataSource.fetchAppointments(for: patientId)
            .map { $0.filter { $0.isPast }.sorted { $0.scheduledDate > $1.scheduledDate } }
            .eraseToAnyPublisher()
    }
    
    func fetchAppointment(id: String) -> AnyPublisher<AppointmentEntity, Error> {
        dataSource.fetchAppointment(id: id)
    }
}
