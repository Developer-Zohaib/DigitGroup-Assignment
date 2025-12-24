//
//  MockVitalDataSource.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

final class MockVitalDataSource: VitalDataSourceProtocol {
    
    func fetchVitals(for patientId: String) -> AnyPublisher<[Vital], Error> {
        return Just(Self.mockVitals)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static let mockVitals: [Vital] = {
        let today = Date()
        let calendar = Calendar.current
        let recordedTime = calendar.date(bySettingHour: 10, minute: 30, second: 0, of: today) ?? today
        
        return [
            Vital(
                id: "vital-001",
                type: .heartRate,
                value: 72,
                unit: "bpm",
                recordedAt: recordedTime,
                status: .normal
            ),
            Vital(
                id: "vital-002",
                type: .bloodPressure,
                value: 120,
                unit: "mmHg",
                recordedAt: recordedTime,
                status: .normal
            ),
            Vital(
                id: "vital-003",
                type: .temperature,
                value: 98.6,
                unit: "°F",
                recordedAt: calendar.date(bySettingHour: 8, minute: 15, second: 0, of: today) ?? today,
                status: .normal
            ),
            Vital(
                id: "vital-004",
                type: .oxygenLevel,
                value: 98,
                unit: "%",
                recordedAt: recordedTime,
                status: .normal
            ),
            Vital(
                id: "vital-005",
                type: .respiratoryRate,
                value: 16,
                unit: "br/min",
                recordedAt: recordedTime,
                status: .normal
            )
        ]
    }()
}
