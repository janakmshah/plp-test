//
//  ProductListingsViewModel.swift
//  RetailApp
//
//  Created by Janak Shah on 14/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import Foundation

class ProductListingsViewModel {
    
    // MARK: - Private properties
    
    private let productsService: ProductsService
    private weak var coordinator: AppCoordinator?
    private let priceFormatter: PriceFormatter

    private var products: [ProductDetailsBasic] = [] {
        didSet {
            updateObservables(products: products)
        }
    }
    
    // MARK: - Public properties
    
    let displayProducts: Observable<[ProductCellDisplayable]>
    
    // MARK: - Initialisers
    
    init(coordinator: AppCoordinator,
         productsService: ProductsService = ProductsServiceImplementation(api: API.defaultAPI),
         priceFormatter: PriceFormatter = PriceFormatterImplementation()) {
        
        self.coordinator = coordinator
        self.productsService = productsService
        self.priceFormatter = priceFormatter
        self.displayProducts = Observable<[ProductCellDisplayable]>([])
        
        self.getProducts()
    }
    
    // MARK: - Update data
    
    private func getProducts() {
        
        let group = DispatchGroup()
        var downloadedProducts: Products?
        var groupError: Error?
        
        group.enter()
        OffersServiceImplementation(api: API.defaultAPI).getOffers(for: User.current.id) { result in
            do {
                User.current = User(userOffers: try result.unwrapped())
            } catch {
                groupError = error
            }
            group.leave()
        }
        
        group.enter()
        productsService.getProducts { result in
            do {
                downloadedProducts = try result.unwrapped()
            } catch {
                groupError = error
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.global()) {
            DispatchQueue.main.async {
                guard let newProducts = downloadedProducts else { return }
                
                if let error = groupError {
                    self.coordinator?.show(error: error)
                    return
                }
                
                self.products = newProducts.products
            }
        }
        
    }
    
    // MARK: - User interaction
    
    func openProductDetails(_ index: Int) {
        self.coordinator?.navigateToProductDetail(products[index])
    }
    
    // MARK: - Update views
    
    private func updateObservables(products: [ProductDetailsBasic]) {
        displayProducts.value = products.map {
            ProductCellDisplayableImplementation(title: $0.name,
                                                 imageKey: $0.imageKey,
                                                 price: priceFormatter.formatPrice($0.price),
                                                 offerIds: $0.offerIds)
        }
    }
    
}
