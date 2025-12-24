//
//  AppointmentsViewModel.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

// MARK: - Appointments ViewModel
// Handles appointments list with upcoming/past filtering

protocol AppointmentsViewModelProtocol: AnyObject {
    var state: CurrentValueSubject<AppointmentsViewModel.State, Never> { get }
    var navigationEvent: PassthroughSubject<AppointmentsViewModel.NavigationEvent, Never> { get }
    
    func viewDidLoad()
    func didSelectSegment(_ segment: AppointmentsViewModel.Segment)
    func didSelectAppointment(section: Int, row: Int)
    func didTapAddAppointment()
}

/// Manages appointments data, filtering, and navigation
final class AppointmentsViewModel: AppointmentsViewModelProtocol {
    
    enum Segment: Int {
        case upcoming = 0
        case past = 1
    }
    
    enum Section: Int, CaseIterable {
        case today = 0
        case nextWeek = 1
        
        var title: String {
            switch self {
            case .today: return "Today"
            case .nextWeek: return "Next Week"
            }
        }
    }
    
    struct AppointmentItem: Equatable {
        let id: String
        let doctorName: String
        let specialty: String
        let time: String
        let location: String
        let isVideo: Bool
        let isOnline: Bool
        let isPrimary: Bool
    }
    
    enum State: Equatable {
        case idle
        case loading
        case loaded(SegmentData)
        case empty(String)
        case error(String)
    }
    
    struct SegmentData: Equatable {
        let segment: Segment
        let sections: [[AppointmentItem]]
    }
    
    enum NavigationEvent {
        case showAppointmentDetail(String)
        case showAddAppointment
    }
    
    // MARK: - Properties
    
    let state = CurrentValueSubject<State, Never>(.idle)
    let navigationEvent = PassthroughSubject<NavigationEvent, Never>()
    
    private let fetchAppointmentsUseCase: FetchAppointmentsUseCaseProtocol
    private let patientId: String
    private var cancellables = Set<AnyCancellable>()
    private var currentSegment: Segment = .upcoming
    private var allAppointments: [AppointmentEntity] = []
    
    // MARK: - Init
    
    init(fetchAppointmentsUseCase: FetchAppointmentsUseCaseProtocol, patientId: String) {
        self.fetchAppointmentsUseCase = fetchAppointmentsUseCase
        self.patientId = patientId
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        fetchAppointments()
    }
    
    func didSelectSegment(_ segment: Segment) {
        currentSegment = segment
        updateState()
    }
    
    func didSelectAppointment(section: Int, row: Int) {
        let appointments = currentSegment == .upcoming ? upcomingAppointments() : pastAppointments()
        guard section < appointments.count,
              row < appointments[section].count else { return }
        
        let appointment = appointments[section][row]
        navigationEvent.send(.showAppointmentDetail(appointment.id))
    }
    
    func didTapAddAppointment() {
        navigationEvent.send(.showAddAppointment)
    }
    
    // MARK: - Private Methods
    
    private func fetchAppointments() {
        state.send(.loading)
        
        fetchAppointmentsUseCase.execute(patientId: patientId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.state.send(.error(error.localizedDescription))
                    }
                },
                receiveValue: { [weak self] appointments in
                    self?.allAppointments = appointments
                    self?.updateState()
                }
            )
            .store(in: &cancellables)
    }
    
    private func updateState() {
        switch currentSegment {
        case .upcoming:
            let upcoming = upcomingAppointments()
            if upcoming.flatMap({ $0 }).isEmpty {
                state.send(.empty("No upcoming appointments"))
            } else {
                let items = upcoming.map { $0.map(mapToItem) }
                state.send(.loaded(SegmentData(segment: .upcoming, sections: items)))
            }
        case .past:
            let past = pastAppointments()
            if past.flatMap({ $0 }).isEmpty {
                state.send(.empty("No past appointments"))
            } else {
                let items = past.map { $0.map(mapToItem) }
                state.send(.loaded(SegmentData(segment: .past, sections: items)))
            }
        }
    }
    
    private func upcomingAppointments() -> [[AppointmentEntity]] {
        let upcoming = allAppointments.filter { $0.isUpcoming }
        let today = upcoming.filter { $0.isToday }
        let nextWeek = upcoming.filter { !$0.isToday }
        return [today, nextWeek]
    }
    
    private func pastAppointments() -> [[AppointmentEntity]] {
        let past = allAppointments.filter { $0.isPast }
        return [past, []]
    }
    
    private func mapToItem(_ appointment: AppointmentEntity) -> AppointmentItem {
        let formatter = DateFormatter()
        formatter.dateFormat = appointment.isToday ? "h:mm a" : "EEE, h:mm a"
        
        return AppointmentItem(
            id: appointment.id,
            doctorName: appointment.doctorName,
            specialty: appointment.specialty,
            time: formatter.string(from: appointment.scheduledDate),
            location: appointment.location.displayText,
            isVideo: appointment.type.isVideo,
            isOnline: appointment.type.isVideo,
            isPrimary: appointment.isToday
        )
    }
}
