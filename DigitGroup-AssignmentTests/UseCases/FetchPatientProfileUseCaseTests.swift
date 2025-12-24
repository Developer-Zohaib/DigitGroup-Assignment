//
//  FetchPatientProfileUseCaseTests.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import XCTest
import Combine
@testable import DigitGroup_Assignment

final class FetchPatientProfileUseCaseTests: XCTestCase {
    
    private var sut: FetchPatientProfileUseCase!
    private var mockRepository: MockPatientRepository!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPatientRepository()
        sut = FetchPatientProfileUseCase(repository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_execute_callsRepository() {
        let expectation = expectation(description: "Repository called")
        
        sut.execute()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockRepository.fetchCurrentPatientCallCount, 1)
    }
    
    func test_execute_success_returnsPatient() {
        let expectation = expectation(description: "Patient returned")
        var receivedPatient: Patient?
        
        sut.execute()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { patient in
                    receivedPatient = patient
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedPatient)
        XCTAssertEqual(receivedPatient?.firstName, "Sarah")
    }
    
    func test_execute_failure_propagatesError() {
        let expectation = expectation(description: "Error propagated")
        mockRepository.fetchCurrentPatientResult = .failure(NSError(domain: "Test", code: 500))
        
        sut.execute()
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
