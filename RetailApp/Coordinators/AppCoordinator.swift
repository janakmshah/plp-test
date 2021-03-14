//
//  AppCoordinator.swift
//  RetailApp
//
//  Created by Janak Shah on 14/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import UIKit

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
    
    func show(error: Error) {
        let alertController = UIAlertController(title: "Oh no!", message: error.localizedDescription, preferredStyle: .alert)
        self.rootNavController?.present(alertController, animated: true)
    }
    
}
