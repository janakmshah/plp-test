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
        
        productsService.getProducts { [weak self] result in
            do {
                self?.products = try result.unwrapped().products
            } catch {
                print(error.localizedDescription)
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
                                                 price: priceFormatter.formatPrice($0.price))
        }
    }
    
    // MARK: - Helpers
    
    private func badgeToDisplay(userOffers: UserOffers) -> String? {
        
        let offerIds: [String] = [] // e.g. ["2", "3", "5", "4"]
        
        let availableBadgesString = "" // e.g. "loyalty:SLOTTED,BONUS||sale:PRIORITY_ACCESS,REDUCED"
        
        let availableBadgesInPriority: [String] = []
        /* e.g.
         [
         "loyalty:SLOTTED,BONUS",
         "sale:PRIORITY_ACCESS,REDUCED"
         ]
         */
        
        let prioritisedBadgeObjects: [Badge] = []
        /* e.g.
         [
         [name: "loyalty", types: ["SLOTTED", "BONUS"],
         [name: "sale", types: ["PRIORITY_ACCESS", "REDUCED"]
         ]
         */
        
        let matchingOffers = userOffers.offers.filter { offerIds.contains($0.id) }
        
        let displayOffer = prioritisedBadgeObjects.first { badge -> Bool in
            for type in badge.types {
                for offer in matchingOffers {
                    if offer.id == type {
                        return true
                    }
                }
            }
            return false
        }
        
        return displayOffer?.name
        
    }
}

struct UserOffers: Codable {
    let availableBadges: [Badge]
    let offers: [Offer]
}

struct Badge: Codable {
    let name: String
    let types: [String]
}

/*
 "offers": [
 {
 "id": "6",
 "title": "Reductions!",
 "type": "REDUCED"
 }
 */
struct Offer: Codable {
    let id: String
    let title: String
    let type: String
}
