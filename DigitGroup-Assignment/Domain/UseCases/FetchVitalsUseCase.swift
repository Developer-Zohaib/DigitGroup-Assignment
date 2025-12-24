//
//  FetchVitalsUseCase.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

protocol FetchVitalsUseCaseProtocol {
    func execute(patientId: String) -> AnyPublisher<[Vital], Error>
    func executeLatest(patientId: String) -> AnyPublisher<[Vital], Error>
}

final class FetchVitalsUseCase: FetchVitalsUseCaseProtocol {
    
    private let repository: VitalRepositoryProtocol
    
    init(repository: VitalRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(patientId: String) -> AnyPublisher<[Vital], Error> {
        return repository.fetchVitals(for: patientId)
    }
    
    func executeLatest(patientId: String) -> AnyPublisher<[Vital], Error> {
        return repository.fetchLatestVitals(for: patientId)
    }
}
