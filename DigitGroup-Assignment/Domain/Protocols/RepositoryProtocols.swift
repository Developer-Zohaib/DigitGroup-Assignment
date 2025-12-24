//
//  RepositoryProtocols.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

// MARK: - Repository Protocols
// Abstractions for data access - implementations can be swapped (Mock/Network)

/// Patient data access
protocol PatientRepositoryProtocol {
    func fetchPatient(id: String) -> AnyPublisher<Patient, Error>
    func fetchCurrentPatient() -> AnyPublisher<Patient, Error>
}

/// Appointment data access with filtering
protocol AppointmentRepositoryProtocol {
    func fetchAppointments(for patientId: String) -> AnyPublisher<[AppointmentEntity], Error>
    func fetchUpcomingAppointments(for patientId: String) -> AnyPublisher<[AppointmentEntity], Error>
    func fetchPastAppointments(for patientId: String) -> AnyPublisher<[AppointmentEntity], Error>
    func fetchAppointment(id: String) -> AnyPublisher<AppointmentEntity, Error>
}

/// Vital signs data access
protocol VitalRepositoryProtocol {
    func fetchVitals(for patientId: String) -> AnyPublisher<[Vital], Error>
    func fetchLatestVitals(for patientId: String) -> AnyPublisher<[Vital], Error>
    func fetchVitalHistory(for patientId: String, type: VitalType) -> AnyPublisher<[Vital], Error>
}
