//
//  MockUseCases.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine
@testable import DigitGroup_Assignment

final class MockFetchPatientProfileUseCase: FetchPatientProfileUseCaseProtocol {
    
    var result: Result<Patient, Error> = .success(MockPatientDataSource.mockPatient)
    var executeCallCount = 0
    
    func execute() -> AnyPublisher<Patient, Error> {
        executeCallCount += 1
        return result.publisher.eraseToAnyPublisher()
    }
}

final class MockFetchAppointmentsUseCase: FetchAppointmentsUseCaseProtocol {
    
    var executeResult: Result<[AppointmentEntity], Error> = .success(MockAppointmentDataSource.mockAppointments)
    var upcomingResult: Result<[AppointmentEntity], Error> = .success([])
    var pastResult: Result<[AppointmentEntity], Error> = .success([])
    
    var executeCallCount = 0
    var upcomingCallCount = 0
    var pastCallCount = 0
    
    func execute(patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        executeCallCount += 1
        return executeResult.publisher.eraseToAnyPublisher()
    }
    
    func executeUpcoming(patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        upcomingCallCount += 1
        return upcomingResult.publisher.eraseToAnyPublisher()
    }
    
    func executePast(patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        pastCallCount += 1
        return pastResult.publisher.eraseToAnyPublisher()
    }
}

final class MockFetchAppointmentDetailUseCase: FetchAppointmentDetailUseCaseProtocol {
    
    var result: Result<AppointmentEntity, Error>?
    var executeCallCount = 0
    var lastAppointmentId: String?
    
    func execute(appointmentId: String) -> AnyPublisher<AppointmentEntity, Error> {
        executeCallCount += 1
        lastAppointmentId = appointmentId
        
        if let result = result {
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

final class MockFetchVitalsUseCase: FetchVitalsUseCaseProtocol {
    
    var executeResult: Result<[Vital], Error> = .success(MockVitalDataSource.mockVitals)
    var latestResult: Result<[Vital], Error> = .success(MockVitalDataSource.mockVitals)
    
    var executeCallCount = 0
    var latestCallCount = 0
    
    func execute(patientId: String) -> AnyPublisher<[Vital], Error> {
        executeCallCount += 1
        return executeResult.publisher.eraseToAnyPublisher()
    }
    
    func executeLatest(patientId: String) -> AnyPublisher<[Vital], Error> {
        latestCallCount += 1
        return latestResult.publisher.eraseToAnyPublisher()
    }
}
