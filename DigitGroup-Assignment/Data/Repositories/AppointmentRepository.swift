//
//  AppointmentRepository.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

final class AppointmentRepository: AppointmentRepositoryProtocol {
    
    private let dataSource: AppointmentDataSourceProtocol
    
    init(dataSource: AppointmentDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchAppointments(for patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        return dataSource.fetchAppointments(for: patientId)
    }
    
    func fetchUpcomingAppointments(for patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        return dataSource.fetchAppointments(for: patientId)
            .map { appointments in
                appointments.filter { $0.isUpcoming }
                    .sorted { $0.scheduledDate < $1.scheduledDate }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchPastAppointments(for patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        return dataSource.fetchAppointments(for: patientId)
            .map { appointments in
                appointments.filter { $0.isPast }
                    .sorted { $0.scheduledDate > $1.scheduledDate }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchAppointment(id: String) -> AnyPublisher<AppointmentEntity, Error> {
        return dataSource.fetchAppointment(id: id)
    }
}
