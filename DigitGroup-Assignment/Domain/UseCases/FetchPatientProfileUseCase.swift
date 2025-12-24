//
//  FetchPatientProfileUseCase.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

// MARK: - Fetch Patient Profile Use Case

protocol FetchPatientProfileUseCaseProtocol {
    func execute() -> AnyPublisher<Patient, Error>
}

/// Fetches current patient's profile data
final class FetchPatientProfileUseCase: FetchPatientProfileUseCaseProtocol {
    private let repository: PatientRepositoryProtocol
    
    init(repository: PatientRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<Patient, Error> {
        repository.fetchCurrentPatient()
    }
}
