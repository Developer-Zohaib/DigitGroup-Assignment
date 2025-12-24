//
//  AppointmentDetailViewModel.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

protocol AppointmentDetailViewModelProtocol: AnyObject {
    var state: CurrentValueSubject<AppointmentDetailViewModel.State, Never> { get }
    var navigationEvent: PassthroughSubject<AppointmentDetailViewModel.NavigationEvent, Never> { get }
    
    func viewDidLoad()
    func didTapBack()
    func didTapGetDirections()
    func didTapJoinCall()
    func didTapReschedule()
    func didTapCancel()
}

final class AppointmentDetailViewModel: AppointmentDetailViewModelProtocol {
    
    // MARK: - Types
    
    enum State: Equatable {
        case idle
        case loading
        case loaded(AppointmentDetail)
        case error(String)
    }
    
    struct AppointmentDetail: Equatable {
        let doctorName: String
        let specialty: String
        let dateFormatted: String
        let timeFormatted: String
        let locationName: String
        let locationAddress: String
        let isVideo: Bool
        let latitude: Double?
        let longitude: Double?
        let status: String
    }
    
    enum NavigationEvent {
        case dismiss
        case openMaps(latitude: Double, longitude: Double)
        case joinVideoCall(String)
        case showReschedule(String)
        case showCancelConfirmation(String)
    }
    
    // MARK: - Properties
    
    let state = CurrentValueSubject<State, Never>(.idle)
    let navigationEvent = PassthroughSubject<NavigationEvent, Never>()
    
    private let fetchAppointmentUseCase: FetchAppointmentDetailUseCaseProtocol
    private let appointmentId: String
    private var cancellables = Set<AnyCancellable>()
    private var currentAppointment: AppointmentEntity?
    
    // MARK: - Init
    
    init(fetchAppointmentUseCase: FetchAppointmentDetailUseCaseProtocol, appointmentId: String) {
        self.fetchAppointmentUseCase = fetchAppointmentUseCase
        self.appointmentId = appointmentId
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        fetchAppointmentDetail()
    }
    
    func didTapBack() {
        navigationEvent.send(.dismiss)
    }
    
    func didTapGetDirections() {
        guard let appointment = currentAppointment,
              let coords = appointment.location.coordinates else { return }
        navigationEvent.send(.openMaps(latitude: coords.latitude, longitude: coords.longitude))
    }
    
    func didTapJoinCall() {
        guard let appointment = currentAppointment, appointment.type.isVideo else { return }
        navigationEvent.send(.joinVideoCall(appointment.id))
    }
    
    func didTapReschedule() {
        navigationEvent.send(.showReschedule(appointmentId))
    }
    
    func didTapCancel() {
        navigationEvent.send(.showCancelConfirmation(appointmentId))
    }
    
    // MARK: - Private Methods
    
    private func fetchAppointmentDetail() {
        state.send(.loading)
        
        fetchAppointmentUseCase.execute(appointmentId: appointmentId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.state.send(.error(error.localizedDescription))
                    }
                },
                receiveValue: { [weak self] appointment in
                    self?.currentAppointment = appointment
                    self?.state.send(.loaded(self?.mapToDetail(appointment) ?? Self.emptyDetail))
                }
            )
            .store(in: &cancellables)
    }
    
    private func mapToDetail(_ appointment: AppointmentEntity) -> AppointmentDetail {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        return AppointmentDetail(
            doctorName: appointment.doctorName,
            specialty: appointment.specialty,
            dateFormatted: dateFormatter.string(from: appointment.scheduledDate),
            timeFormatted: timeFormatter.string(from: appointment.scheduledDate),
            locationName: appointment.location.name,
            locationAddress: appointment.location.address ?? "",
            isVideo: appointment.type.isVideo,
            latitude: appointment.location.coordinates?.latitude,
            longitude: appointment.location.coordinates?.longitude,
            status: appointment.status.rawValue.capitalized
        )
    }
    
    private static let emptyDetail = AppointmentDetail(
        doctorName: "",
        specialty: "",
        dateFormatted: "",
        timeFormatted: "",
        locationName: "",
        locationAddress: "",
        isVideo: false,
        latitude: nil,
        longitude: nil,
        status: ""
    )
}
