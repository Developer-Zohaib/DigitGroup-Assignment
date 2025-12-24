//
//  DataSourceProtocols.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

// MARK: - Data Source Protocols
// Abstractions for data fetching - swap Mock with Network implementation

protocol PatientDataSourceProtocol {
    func fetchPatient(id: String) -> AnyPublisher<Patient, Error>
    func fetchCurrentPatient() -> AnyPublisher<Patient, Error>
}

protocol AppointmentDataSourceProtocol {
    func fetchAppointments(for patientId: String) -> AnyPublisher<[AppointmentEntity], Error>
    func fetchAppointment(id: String) -> AnyPublisher<AppointmentEntity, Error>
}

protocol VitalDataSourceProtocol {
    func fetchVitals(for patientId: String) -> AnyPublisher<[Vital], Error>
}
