//
//  MockRepositories.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine
@testable import DigitGroup_Assignment

final class MockPatientRepository: PatientRepositoryProtocol {
    
    var fetchPatientResult: Result<Patient, Error> = .success(MockPatientDataSource.mockPatient)
    var fetchCurrentPatientResult: Result<Patient, Error> = .success(MockPatientDataSource.mockPatient)
    
    var fetchPatientCallCount = 0
    var fetchCurrentPatientCallCount = 0
    
    func fetchPatient(id: String) -> AnyPublisher<Patient, Error> {
        fetchPatientCallCount += 1
        return fetchPatientResult.publisher.eraseToAnyPublisher()
    }
    
    func fetchCurrentPatient() -> AnyPublisher<Patient, Error> {
        fetchCurrentPatientCallCount += 1
        return fetchCurrentPatientResult.publisher.eraseToAnyPublisher()
    }
}

final class MockAppointmentRepository: AppointmentRepositoryProtocol {
    
    var fetchAppointmentsResult: Result<[AppointmentEntity], Error> = .success(MockAppointmentDataSource.mockAppointments)
    var fetchUpcomingResult: Result<[AppointmentEntity], Error> = .success([])
    var fetchPastResult: Result<[AppointmentEntity], Error> = .success([])
    var fetchAppointmentResult: Result<AppointmentEntity, Error>?
    
    var fetchAppointmentsCallCount = 0
    var fetchUpcomingCallCount = 0
    var fetchPastCallCount = 0
    var fetchAppointmentCallCount = 0
    
    func fetchAppointments(for patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        fetchAppointmentsCallCount += 1
        return fetchAppointmentsResult.publisher.eraseToAnyPublisher()
    }
    
    func fetchUpcomingAppointments(for patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        fetchUpcomingCallCount += 1
        return fetchUpcomingResult.publisher.eraseToAnyPublisher()
    }
    
    func fetchPastAppointments(for patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        fetchPastCallCount += 1
        return fetchPastResult.publisher.eraseToAnyPublisher()
    }
    
    func fetchAppointment(id: String) -> AnyPublisher<AppointmentEntity, Error> {
        fetchAppointmentCallCount += 1
        if let result = fetchAppointmentResult {
            return result.publisher.eraseToAnyPublisher()
        }
        if let appointment = MockAppointmentDataSource.mockAppointments.first {
            return Just(appointment)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "NotFound", code: 404))
            .eraseToAnyPublisher()
    }
}

final class MockVitalRepository: VitalRepositoryProtocol {
    
    var fetchVitalsResult: Result<[Vital], Error> = .success(MockVitalDataSource.mockVitals)
    var fetchLatestResult: Result<[Vital], Error> = .success(MockVitalDataSource.mockVitals)
    var fetchHistoryResult: Result<[Vital], Error> = .success([])
    
    var fetchVitalsCallCount = 0
    var fetchLatestCallCount = 0
    var fetchHistoryCallCount = 0
    
    func fetchVitals(for patientId: String) -> AnyPublisher<[Vital], Error> {
        fetchVitalsCallCount += 1
        return fetchVitalsResult.publisher.eraseToAnyPublisher()
    }
    
    func fetchLatestVitals(for patientId: String) -> AnyPublisher<[Vital], Error> {
        fetchLatestCallCount += 1
        return fetchLatestResult.publisher.eraseToAnyPublisher()
    }
    
    func fetchVitalHistory(for patientId: String, type: VitalType) -> AnyPublisher<[Vital], Error> {
        fetchHistoryCallCount += 1
        return fetchHistoryResult.publisher.eraseToAnyPublisher()
    }
}
