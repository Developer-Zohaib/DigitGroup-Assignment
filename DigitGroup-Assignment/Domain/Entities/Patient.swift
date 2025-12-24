//
//  Patient.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation

struct Patient: Equatable {
    let id: String
    let firstName: String
    let lastName: String
    let dateOfBirth: Date
    let bloodType: BloodType
    let height: Measurement<UnitLength>
    let weight: Measurement<UnitMass>
    let isOnline: Bool
    let medicalInfo: MedicalInfo
    let administrativeInfo: AdministrativeInfo
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var age: Int {
        Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
    }
}

enum BloodType: String, CaseIterable {
    case aPositive = "A+"
    case aNegative = "A-"
    case bPositive = "B+"
    case bNegative = "B-"
    case abPositive = "AB+"
    case abNegative = "AB-"
    case oPositive = "O+"
    case oNegative = "O-"
}

struct MedicalInfo: Equatable {
    let allergies: [String]
    let chronicConditions: [String]
    let currentMedications: [Medication]
}

struct Medication: Equatable {
    let name: String
    let dosage: String
}

struct AdministrativeInfo: Equatable {
    let insurance: Insurance
    let emergencyContact: EmergencyContact
}

struct Insurance: Equatable {
    let provider: String
    let policyNumber: String
}

struct EmergencyContact: Equatable {
    let name: String
    let relationship: String
    let phoneNumber: String
}
