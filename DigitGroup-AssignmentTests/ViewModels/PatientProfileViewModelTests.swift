//
//  PatientProfileViewModelTests.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import XCTest
import Combine
@testable import DigitGroup_Assignment

final class PatientProfileViewModelTests: XCTestCase {
    
    private var sut: PatientProfileViewModel!
    private var mockUseCase: MockFetchPatientProfileUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchPatientProfileUseCase()
        sut = PatientProfileViewModel(fetchPatientUseCase: mockUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initial State
    
    func test_initialState_isIdle() {
        XCTAssertEqual(sut.state.value, .idle)
    }
    
    // MARK: - viewDidLoad
    
    func test_viewDidLoad_setsLoadingState() {
        let expectation = expectation(description: "State changes to loading")
        var states: [PatientProfileViewModel.State] = []
        
        sut.state
            .dropFirst()
            .sink { state in
                states.append(state)
                if states.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.viewDidLoad()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(states.first, .loading)
    }
    
    func test_viewDidLoad_callsUseCase() {
        sut.viewDidLoad()
        
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
    }
    
    func test_viewDidLoad_success_setsLoadedState() {
        let expectation = expectation(description: "State changes to loaded")
        
        sut.state
            .dropFirst(2)
            .sink { state in
                if case .loaded = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.viewDidLoad()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_viewDidLoad_failure_setsErrorState() {
        let expectation = expectation(description: "State changes to error")
        mockUseCase.result = .failure(NSError(domain: "Test", code: 500))
        
        sut.state
            .dropFirst(2)
            .sink { state in
                if case .error = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.viewDidLoad()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Navigation Events
    
    func test_didTapAppointments_sendsNavigationEvent() {
        let expectation = expectation(description: "Navigation event sent")
        
        sut.navigationEvent
            .sink { event in
                if case .showAppointments = event {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.didTapAppointments()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_didTapVitals_sendsNavigationEvent() {
        let expectation = expectation(description: "Navigation event sent")
        
        sut.navigationEvent
            .sink { event in
                if case .showVitals = event {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.didTapVitals()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Data Mapping
    
    func test_viewDidLoad_mapsPatientDataCorrectly() {
        let expectation = expectation(description: "Profile data mapped")
        
        sut.state
            .dropFirst(2)
            .sink { state in
                if case .loaded(let data) = state {
                    XCTAssertEqual(data.fullName, "Sarah Johnson")
                    XCTAssertEqual(data.bloodType, "A+")
                    XCTAssertFalse(data.allergies.isEmpty)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.viewDidLoad()
        
        wait(for: [expectation], timeout: 1.0)
    }
}
