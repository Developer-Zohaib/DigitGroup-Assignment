//
//  VitalRepository.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

/// Vital repository with filtering for latest readings and history
final class VitalRepository: VitalRepositoryProtocol {
    private let dataSource: VitalDataSourceProtocol
    
    init(dataSource: VitalDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchVitals(for patientId: String) -> AnyPublisher<[Vital], Error> {
        dataSource.fetchVitals(for: patientId)
    }
    
    /// Returns only the most recent reading for each vital type
    func fetchLatestVitals(for patientId: String) -> AnyPublisher<[Vital], Error> {
        dataSource.fetchVitals(for: patientId)
            .map { vitals in
                var latestByType: [VitalType: Vital] = [:]
                for vital in vitals {
                    if let existing = latestByType[vital.type], vital.recordedAt <= existing.recordedAt {
                        continue
                    }
                    latestByType[vital.type] = vital
                }
                return Array(latestByType.values)
            }
            .eraseToAnyPublisher()
    }
    
    /// Returns history for a specific vital type, sorted by date
    func fetchVitalHistory(for patientId: String, type: VitalType) -> AnyPublisher<[Vital], Error> {
        dataSource.fetchVitals(for: patientId)
            .map { $0.filter { $0.type == type }.sorted { $0.recordedAt > $1.recordedAt } }
            .eraseToAnyPublisher()
    }
}
