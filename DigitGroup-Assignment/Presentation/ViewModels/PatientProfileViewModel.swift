//
//  PatientProfileViewModel.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

protocol PatientProfileViewModelProtocol: AnyObject {
    var state: CurrentValueSubject<PatientProfileViewModel.State, Never> { get }
    var navigationEvent: PassthroughSubject<PatientProfileViewModel.NavigationEvent, Never> { get }
    
    func viewDidLoad()
    func didTapAppointments()
    func didTapVitals()
    func didTapAllergies()
    func didTapConditions()
    func didTapMedications()
    func didTapInsurance()
    func didTapEmergencyContact()
}

final class PatientProfileViewModel: PatientProfileViewModelProtocol {
    
    // MARK: - State
    
    enum State: Equatable {
        case idle
        case loading
        case loaded(ProfileData)
        case error(String)
    }
    
    struct ProfileData: Equatable {
        let fullName: String
        let age: Int
        let isOnline: Bool
        let bloodType: String
        let height: String
        let weight: String
        let allergies: String
        let conditions: String
        let medications: String
        let insuranceProvider: String
        let insuranceId: String
        let emergencyContactName: String
        let emergencyContactRelation: String
    }
    
    // MARK: - Navigation Events
    
    enum NavigationEvent {
        case showAppointments
        case showVitals
        case showAllergyDetail([String])
        case showConditionDetail([String])
        case showMedicationDetail([Medication])
        case showInsuranceDetail(Insurance)
        case showEmergencyContactDetail(EmergencyContact)
    }
    
    // MARK: - Properties
    
    let state = CurrentValueSubject<State, Never>(.idle)
    let navigationEvent = PassthroughSubject<NavigationEvent, Never>()
    
    private let fetchPatientUseCase: FetchPatientProfileUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentPatient: Patient?
    
    // MARK: - Init
    
    init(fetchPatientUseCase: FetchPatientProfileUseCaseProtocol) {
        self.fetchPatientUseCase = fetchPatientUseCase
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        fetchProfile()
    }
    
    func didTapAppointments() {
        navigationEvent.send(.showAppointments)
    }
    
    func didTapVitals() {
        navigationEvent.send(.showVitals)
    }
    
    func didTapAllergies() {
        guard let patient = currentPatient else { return }
        navigationEvent.send(.showAllergyDetail(patient.medicalInfo.allergies))
    }
    
    func didTapConditions() {
        guard let patient = currentPatient else { return }
        navigationEvent.send(.showConditionDetail(patient.medicalInfo.chronicConditions))
    }
    
    func didTapMedications() {
        guard let patient = currentPatient else { return }
        navigationEvent.send(.showMedicationDetail(patient.medicalInfo.currentMedications))
    }
    
    func didTapInsurance() {
        guard let patient = currentPatient else { return }
        navigationEvent.send(.showInsuranceDetail(patient.administrativeInfo.insurance))
    }
    
    func didTapEmergencyContact() {
        guard let patient = currentPatient else { return }
        navigationEvent.send(.showEmergencyContactDetail(patient.administrativeInfo.emergencyContact))
    }
    
    // MARK: - Private Methods
    
    private func fetchProfile() {
        state.send(.loading)
        
        fetchPatientUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.state.send(.error(error.localizedDescription))
                    }
                },
                receiveValue: { [weak self] patient in
                    self?.currentPatient = patient
                    self?.state.send(.loaded(self?.mapToProfileData(patient) ?? Self.emptyProfileData))
                }
            )
            .store(in: &cancellables)
    }
    
    private func mapToProfileData(_ patient: Patient) -> ProfileData {
        let heightFormatter = MeasurementFormatter()
        heightFormatter.unitStyle = .short
        
        let weightFormatter = MeasurementFormatter()
        weightFormatter.unitStyle = .short
        
        return ProfileData(
            fullName: patient.fullName,
            age: patient.age,
            isOnline: patient.isOnline,
            bloodType: patient.bloodType.rawValue,
            height: heightFormatter.string(from: patient.height),
            weight: weightFormatter.string(from: patient.weight),
            allergies: patient.medicalInfo.allergies.joined(separator: ", "),
            conditions: patient.medicalInfo.chronicConditions.joined(separator: ", "),
            medications: patient.medicalInfo.currentMedications.map { "\($0.name) \($0.dosage)" }.joined(separator: ", "),
            insuranceProvider: patient.administrativeInfo.insurance.provider,
            insuranceId: patient.administrativeInfo.insurance.policyNumber,
            emergencyContactName: patient.administrativeInfo.emergencyContact.name,
            emergencyContactRelation: patient.administrativeInfo.emergencyContact.relationship
        )
    }
    
    private static let emptyProfileData = ProfileData(
        fullName: "",
        age: 0,
        isOnline: false,
        bloodType: "",
        height: "",
        weight: "",
        allergies: "",
        conditions: "",
        medications: "",
        insuranceProvider: "",
        insuranceId: "",
        emergencyContactName: "",
        emergencyContactRelation: ""
    )
}
