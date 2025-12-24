//
//  MockPatientDataSource.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

/// Mock patient data for development/testing
final class MockPatientDataSource: PatientDataSourceProtocol {
    
    func fetchPatient(id: String) -> AnyPublisher<Patient, Error> {
        Just(Self.mockPatient)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchCurrentPatient() -> AnyPublisher<Patient, Error> {
        return Just(Self.mockPatient)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static let mockPatient = Patient(
        id: "patient-001",
        firstName: "Sarah",
        lastName: "Johnson",
        dateOfBirth: Calendar.current.date(byAdding: .year, value: -35, to: Date()) ?? Date(),
        bloodType: .aPositive,
        height: Measurement(value: 170, unit: .centimeters),
        weight: Measurement(value: 65, unit: .kilograms),
        isOnline: true,
        medicalInfo: MedicalInfo(
            allergies: ["Peanuts", "Penicillin"],
            chronicConditions: ["Hypertension"],
            currentMedications: [
                Medication(name: "Lisinopril", dosage: "10mg")
            ]
        ),
        administrativeInfo: AdministrativeInfo(
            insurance: Insurance(
                provider: "BlueCross",
                policyNumber: "8849302"
            ),
            emergencyContact: EmergencyContact(
                name: "John Doe",
                relationship: "Husband",
                phoneNumber: "+1-555-123-4567"
            )
        )
    )
}
