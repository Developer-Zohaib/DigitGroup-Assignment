//
//  PatientRepository.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

final class PatientRepository: PatientRepositoryProtocol {
    
    private let dataSource: PatientDataSourceProtocol
    
    init(dataSource: PatientDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchPatient(id: String) -> AnyPublisher<Patient, Error> {
        return dataSource.fetchPatient(id: id)
    }
    
    func fetchCurrentPatient() -> AnyPublisher<Patient, Error> {
        return dataSource.fetchCurrentPatient()
    }
}
