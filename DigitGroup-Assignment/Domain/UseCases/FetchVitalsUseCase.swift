//
//  FetchVitalsUseCase.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

// MARK: - Fetch Vitals Use Case

protocol FetchVitalsUseCaseProtocol {
    func execute(patientId: String) -> AnyPublisher<[Vital], Error>
    func executeLatest(patientId: String) -> AnyPublisher<[Vital], Error>
}

/// Fetches patient vitals (all or latest readings)
final class FetchVitalsUseCase: FetchVitalsUseCaseProtocol {
    private let repository: VitalRepositoryProtocol
    
    init(repository: VitalRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(patientId: String) -> AnyPublisher<[Vital], Error> {
        repository.fetchVitals(for: patientId)
    }
    
    func executeLatest(patientId: String) -> AnyPublisher<[Vital], Error> {
        repository.fetchLatestVitals(for: patientId)
    }
}
