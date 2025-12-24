//
//  AppCoordinator.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit
import Combine

final class AppCoordinator: Coordinator {
    
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
        showMainTabBar()
    }
    
    private func showMainTabBar() {
        let tabBarController = UITabBarController()
        
        let profileCoordinator = PatientFlowCoordinator(
            navigationController: UINavigationController(),
            dependencyContainer: dependencyContainer
        )
        addChild(profileCoordinator)
        profileCoordinator.start()
        profileCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        let appointmentsCoordinator = AppointmentsCoordinator(
            navigationController: UINavigationController(),
            dependencyContainer: dependencyContainer
        )
        addChild(appointmentsCoordinator)
        appointmentsCoordinator.start()
        appointmentsCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Appointments",
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar.fill")
        )
        
        let vitalsCoordinator = VitalsCoordinator(
            navigationController: UINavigationController(),
            dependencyContainer: dependencyContainer
        )
        addChild(vitalsCoordinator)
        vitalsCoordinator.start()
        vitalsCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Vitals",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        tabBarController.viewControllers = [
            profileCoordinator.navigationController,
            appointmentsCoordinator.navigationController,
            vitalsCoordinator.navigationController
        ]
        
        navigationController.setViewControllers([tabBarController], animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}
