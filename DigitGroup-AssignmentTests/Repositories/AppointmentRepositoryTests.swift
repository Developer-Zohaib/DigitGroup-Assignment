//
//  AppointmentRepositoryTests.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import XCTest
import Combine
@testable import DigitGroup_Assignment

final class AppointmentRepositoryTests: XCTestCase {
    
    private var sut: AppointmentRepository!
    private var mockDataSource: MockAppointmentDataSource!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockDataSource = MockAppointmentDataSource()
        sut = AppointmentRepository(dataSource: mockDataSource)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockDataSource = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_fetchAppointments_returnsAllAppointments() {
        let expectation = expectation(description: "Appointments fetched")
        var receivedAppointments: [AppointmentEntity]?
        
        sut.fetchAppointments(for: "patient-001")
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { appointments in
                    receivedAppointments = appointments
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedAppointments)
        XCTAssertEqual(receivedAppointments?.count, MockAppointmentDataSource.mockAppointments.count)
    }
    
    func test_fetchUpcomingAppointments_filtersCorrectly() {
        let expectation = expectation(description: "Upcoming appointments fetched")
        var receivedAppointments: [AppointmentEntity]?
        
        sut.fetchUpcomingAppointments(for: "patient-001")
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { appointments in
                    receivedAppointments = appointments
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedAppointments)
        receivedAppointments?.forEach { appointment in
            XCTAssertTrue(appointment.isUpcoming)
        }
    }
    
    func test_fetchPastAppointments_filtersCorrectly() {
        let expectation = expectation(description: "Past appointments fetched")
        var receivedAppointments: [AppointmentEntity]?
        
        sut.fetchPastAppointments(for: "patient-001")
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { appointments in
                    receivedAppointments = appointments
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedAppointments)
        receivedAppointments?.forEach { appointment in
            XCTAssertTrue(appointment.isPast)
        }
    }
    
    func test_fetchAppointment_returnsCorrectAppointment() {
        let expectation = expectation(description: "Appointment fetched")
        let expectedId = MockAppointmentDataSource.mockAppointments.first?.id ?? ""
        var receivedAppointment: AppointmentEntity?
        
        sut.fetchAppointment(id: expectedId)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { appointment in
                    receivedAppointment = appointment
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedAppointment)
        XCTAssertEqual(receivedAppointment?.id, expectedId)
    }
}
