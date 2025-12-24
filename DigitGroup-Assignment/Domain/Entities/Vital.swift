//
//  Vital.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation

struct Vital: Equatable, Identifiable {
    let id: String
    let type: VitalType
    let value: Double
    let unit: String
    let recordedAt: Date
    let status: VitalStatus
    
    var formattedValue: String {
        switch type {
        case .bloodPressure:
            return value.formatted()
        case .heartRate, .respiratoryRate:
            return "\(Int(value))"
        case .temperature:
            return String(format: "%.1f", value)
        case .oxygenLevel:
            return "\(Int(value))"
        }
    }
}

enum VitalType: String, CaseIterable, Equatable {
    case heartRate = "Heart Rate"
    case bloodPressure = "Blood Pressure"
    case temperature = "Temperature"
    case oxygenLevel = "Oxygen Level"
    case respiratoryRate = "Respiratory Rate"
    
    var unit: String {
        switch self {
        case .heartRate: return "bpm"
        case .bloodPressure: return "mmHg"
        case .temperature: return "°F"
        case .oxygenLevel: return "%"
        case .respiratoryRate: return "br/min"
        }
    }
    
    var normalRange: ClosedRange<Double> {
        switch self {
        case .heartRate: return 60...100
        case .bloodPressure: return 90...120
        case .temperature: return 97.0...99.0
        case .oxygenLevel: return 95...100
        case .respiratoryRate: return 12...20
        }
    }
}

enum VitalStatus: String, Equatable {
    case normal = "Normal"
    case elevated = "Elevated"
    case low = "Low"
    case critical = "Critical"
    
    static func status(for value: Double, type: VitalType) -> VitalStatus {
        let range = type.normalRange
        if range.contains(value) {
            return .normal
        } else if value < range.lowerBound {
            return value < range.lowerBound * 0.8 ? .critical : .low
        } else {
            return value > range.upperBound * 1.2 ? .critical : .elevated
        }
    }
}

struct BloodPressureVital: Equatable {
    let systolic: Int
    let diastolic: Int
    let recordedAt: Date
    let status: VitalStatus
    
    var formattedValue: String {
        "\(systolic)/\(diastolic)"
    }
}
