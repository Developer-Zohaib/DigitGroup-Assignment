//
//  VitalsViewModel.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

// MARK: - Vitals ViewModel
// Handles vitals dashboard display and interactions

protocol VitalsViewModelProtocol: AnyObject {
    var state: CurrentValueSubject<VitalsViewModel.State, Never> { get }
    var navigationEvent: PassthroughSubject<VitalsViewModel.NavigationEvent, Never> { get }
    
    func viewDidLoad()
    func didSelectVital(at index: Int)
    func didTapAddVital()
}

/// Manages vitals data and navigation events
final class VitalsViewModel: VitalsViewModelProtocol {
    
    struct VitalItem: Equatable {
        let id: String
        let type: String
        let value: String
        let unit: String
        let status: String
        let statusColor: VitalStatusColor
        let recordedTime: String
    }
    
    enum VitalStatusColor: Equatable {
        case normal
        case warning
        case critical
    }
    
    enum State: Equatable {
        case idle
        case loading
        case loaded(VitalsData)
        case empty(String)
        case error(String)
    }
    
    struct VitalsData: Equatable {
        let dateFormatted: String
        let vitals: [VitalItem]
        let infoMessage: String
    }
    
    enum NavigationEvent {
        case showVitalDetail(String, VitalType)
        case showAddVital
    }
    
    // MARK: - Properties
    
    let state = CurrentValueSubject<State, Never>(.idle)
    let navigationEvent = PassthroughSubject<NavigationEvent, Never>()
    
    private let fetchVitalsUseCase: FetchVitalsUseCaseProtocol
    private let patientId: String
    private var cancellables = Set<AnyCancellable>()
    private var currentVitals: [Vital] = []
    
    // MARK: - Init
    
    init(fetchVitalsUseCase: FetchVitalsUseCaseProtocol, patientId: String) {
        self.fetchVitalsUseCase = fetchVitalsUseCase
        self.patientId = patientId
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        fetchVitals()
    }
    
    func didSelectVital(at index: Int) {
        guard index < currentVitals.count else { return }
        let vital = currentVitals[index]
        navigationEvent.send(.showVitalDetail(vital.id, vital.type))
    }
    
    func didTapAddVital() {
        navigationEvent.send(.showAddVital)
    }
    
    // MARK: - Private Methods
    
    private func fetchVitals() {
        state.send(.loading)
        
        fetchVitalsUseCase.executeLatest(patientId: patientId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.state.send(.error(error.localizedDescription))
                    }
                },
                receiveValue: { [weak self] vitals in
                    self?.currentVitals = vitals
                    self?.updateState(with: vitals)
                }
            )
            .store(in: &cancellables)
    }
    
    private func updateState(with vitals: [Vital]) {
        if vitals.isEmpty {
            state.send(.empty("No vitals recorded yet"))
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        
        let items = vitals.map(mapToItem)
        let infoMessage = generateInfoMessage(from: vitals)
        
        let data = VitalsData(
            dateFormatted: dateFormatter.string(from: Date()),
            vitals: items,
            infoMessage: infoMessage
        )
        
        state.send(.loaded(data))
    }
    
    private func mapToItem(_ vital: Vital) -> VitalItem {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        return VitalItem(
            id: vital.id,
            type: vital.type.rawValue,
            value: vital.formattedValue,
            unit: vital.unit,
            status: vital.status.rawValue,
            statusColor: mapStatusColor(vital.status),
            recordedTime: timeFormatter.string(from: vital.recordedAt)
        )
    }
    
    private func mapStatusColor(_ status: VitalStatus) -> VitalStatusColor {
        switch status {
        case .normal: return .normal
        case .elevated, .low: return .warning
        case .critical: return .critical
        }
    }
    
    private func generateInfoMessage(from vitals: [Vital]) -> String {
        let allNormal = vitals.allSatisfy { $0.status == .normal }
        if allNormal {
            return "Your vitals are trending normally this week. Tap on any card to see detailed history and charts."
        } else {
            let abnormal = vitals.filter { $0.status != .normal }
            let types = abnormal.map { $0.type.rawValue }.joined(separator: ", ")
            return "Some vitals need attention: \(types). Please consult with your doctor."
        }
    }
}
