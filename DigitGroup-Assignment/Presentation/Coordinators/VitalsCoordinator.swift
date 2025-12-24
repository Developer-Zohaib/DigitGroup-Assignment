//
//  VitalsCoordinator.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit
import Combine

final class VitalsCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    
    private let dependencyContainer: DependencyContainerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController, dependencyContainer: DependencyContainerProtocol) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        showVitalsList(animated: false)
    }
    
    func startPushed() {
        showVitalsList(animated: true)
    }
    
    private func showVitalsList(animated: Bool) {
        let viewModel = dependencyContainer.makeVitalsViewModel()
        let viewController = VitalsViewController()
        viewController.configure(with: viewModel)
        
        viewModel.navigationEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handleNavigationEvent(event)
            }
            .store(in: &cancellables)
        
        if animated {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            navigationController.setViewControllers([viewController], animated: false)
        }
    }
    
    private func handleNavigationEvent(_ event: VitalsViewModel.NavigationEvent) {
        switch event {
        case .showVitalDetail(let vitalId, let type):
            showVitalDetail(vitalId: vitalId, type: type)
        case .showAddVital:
            showAddVital()
        }
    }
    
    private func showVitalDetail(vitalId: String, type: VitalType) {
        // Placeholder for vital detail/history screen
    }
    
    private func showAddVital() {
        // Placeholder for add vital flow
    }
}
