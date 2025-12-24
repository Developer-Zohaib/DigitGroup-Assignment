//
//  VitalRepository.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

final class VitalRepository: VitalRepositoryProtocol {
    
    private let dataSource: VitalDataSourceProtocol
    
    init(dataSource: VitalDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchVitals(for patientId: String) -> AnyPublisher<[Vital], Error> {
        return dataSource.fetchVitals(for: patientId)
    }
    
    func fetchLatestVitals(for patientId: String) -> AnyPublisher<[Vital], Error> {
        return dataSource.fetchVitals(for: patientId)
            .map { vitals in
                var latestByType: [VitalType: Vital] = [:]
                for vital in vitals {
                    if let existing = latestByType[vital.type] {
                        if vital.recordedAt > existing.recordedAt {
                            latestByType[vital.type] = vital
                        }
                    } else {
                        latestByType[vital.type] = vital
                    }
                }
                return Array(latestByType.values)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchVitalHistory(for patientId: String, type: VitalType) -> AnyPublisher<[Vital], Error> {
        return dataSource.fetchVitals(for: patientId)
            .map { vitals in
                vitals.filter { $0.type == type }
                    .sorted { $0.recordedAt > $1.recordedAt }
            }
            .eraseToAnyPublisher()
    }
}
