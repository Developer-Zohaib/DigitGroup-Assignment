//
//  MockAppointmentDataSource.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation
import Combine

final class MockAppointmentDataSource: AppointmentDataSourceProtocol {
    
    func fetchAppointments(for patientId: String) -> AnyPublisher<[AppointmentEntity], Error> {
        return Just(Self.mockAppointments)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchAppointment(id: String) -> AnyPublisher<AppointmentEntity, Error> {
        if let appointment = Self.mockAppointments.first(where: { $0.id == id }) {
            return Just(appointment)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "AppointmentNotFound", code: 404))
            .eraseToAnyPublisher()
    }
    
    static let mockAppointments: [AppointmentEntity] = {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            AppointmentEntity(
                id: "apt-001",
                doctorName: "Dr. Sarah Johnson",
                specialty: "Cardiology",
                scheduledDate: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: today) ?? today,
                duration: 30 * 60,
                type: .video,
                location: AppointmentLocation(
                    name: "Video Consultation",
                    address: nil,
                    coordinates: nil
                ),
                status: .scheduled
            ),
            AppointmentEntity(
                id: "apt-002",
                doctorName: "Dr. Mark Lee",
                specialty: "Dermatology",
                scheduledDate: calendar.date(bySettingHour: 14, minute: 30, second: 0, of: today) ?? today,
                duration: 45 * 60,
                type: .inPerson,
                location: AppointmentLocation(
                    name: "City General Hospital",
                    address: "Room 304",
                    coordinates: Coordinates(latitude: 37.7749, longitude: -122.4194)
                ),
                status: .confirmed
            ),
            AppointmentEntity(
                id: "apt-003",
                doctorName: "Dr. Emily Chen",
                specialty: "Orthopedics",
                scheduledDate: calendar.date(byAdding: .day, value: 3, to: today) ?? today,
                duration: 60 * 60,
                type: .inPerson,
                location: AppointmentLocation(
                    name: "Sports Medicine Center",
                    address: "Building A",
                    coordinates: Coordinates(latitude: 37.7849, longitude: -122.4094)
                ),
                status: .scheduled
            )
        ]
    }()
}
