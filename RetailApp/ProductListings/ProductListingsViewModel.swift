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
        var error: Error?
        
        group.enter()
        OffersServiceImplementation(api: API.defaultAPI).getOffers(for: User.current.id) { result in
            switch result {
            case .value(let value):
                User.current = User(userOffers: value)
            case .error(let getOffersError):
                error = getOffersError
            }
            group.leave()
        }
        
        group.enter()
        productsService.getProducts { result in
            switch result {
            case .value(let value):
                downloadedProducts = value
            case .error(let getProductsError):
                error = getProductsError
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.global()) {
            DispatchQueue.main.async {
                guard let newProducts = downloadedProducts else { return }
                
                if let error = error {
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
                                                 badgeKey: badgeToDisplay(offerIds: $0.offerIds))
        }
    }
    
    // MARK: - Helpers
    
    // TODO: This happens for all the listings at once, better to move to ViewModel
    private func badgeToDisplay(offerIds: [String]) -> String? {
                
        let matchingOffers = User.current.userOffers.offers.filter { offerIds.contains($0.id) }
        
        let displayOffer = User.current.userOffers.availableBadges.first { badge -> Bool in
            
            for type in badge.types {
                for offer in matchingOffers where offer.type == type {
                    return true
                }
            }
            
            return false
        }
        
        return displayOffer?.name
        
    }
}
