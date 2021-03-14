//
//  AppCoordinator.swift
//  RetailApp
//
//  Created by Janak Shah on 14/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import UIKit

public enum CoordinatorEvent {
    case openDeepLink
    case permissionsFlow(telematics: Bool, source: Any?)
}

public protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get }
    var rootNavController: UINavigationController? { get }
    var rootViewController: UIViewController? { get set }
    // Where the parent isn't a CUVCoordinator
    func start(from parent: UIViewController)

    // Where the parent is anothero CUVCoordinator
    func start(from parent: Coordinator)
    
    func handleOrPassToParent(_ event: CoordinatorEvent)

}

class AppCoordinator {
    
    var rootNavController: UINavigationController?
    
    func start(from window: UIWindow) {
        rootNavController = UINavigationController(rootViewController: ProductListingsViewController(ProductListingsViewModel(coordinator: self)))
        window.rootViewController = rootNavController
    }
    
    func navigateToProductDetail(_ product: ProductRequest) {
        
        let productDetailsVC = ProductDetailsViewController(viewModel: ProductDetailsViewModel(productRequest: product))
        self.rootNavController?.pushViewController(productDetailsVC, animated: true)
        
    }
    
}
