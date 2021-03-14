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
        
        group.enter()
        OffersServiceImplementation(api: API.defaultAPI).getOffers(for: User.current.id) { result in
            do {
                User.current = User(userOffers: try result.unwrapped())
                print(User.current.userOffers)
                group.leave()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        group.enter()
        productsService.getProducts { result in
            do {
                downloadedProducts = try result.unwrapped()
                group.leave()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: DispatchQueue.global()) {
            DispatchQueue.main.async {
                guard let newProducts = downloadedProducts else { return }
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
                                                 price: priceFormatter.formatPrice($0.price))
        }
    }
    
    // MARK: - Helpers
    
    private func badgeToDisplay(userOffers: UserOffers) -> String? {
        
        let offerIds: [String] = [] // e.g. ["2", "3", "5", "4"]
        
        let matchingOffers = userOffers.offers.filter { offerIds.contains($0.id) }
        
        let displayOffer = User.current.userOffers.availableBadges.first { badge -> Bool in
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

struct User {
    
    let userOffers: UserOffers
    let id = "1"
    
    static var current = User(userOffers: UserOffers())
    
}

struct UserOffers: Codable {
    let availableBadges: [Badge]
    let offers: [Offer]
    
    init() {
        self.availableBadges = []
        self.offers = []
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.offers = try container.decode([Offer].self, forKey: .offers)
        
        // "loyalty:SLOTTED,BONUS||sale:PRIORITY_ACCESS,REDUCED"
        let availableBadgesString = try container.decode(String.self, forKey: .availableBadges)
        
        /* [
            "loyalty:SLOTTED,BONUS",
            "sale:PRIORITY_ACCESS,REDUCED"
         ] */
        let availableBadgesArray = availableBadgesString.components(separatedBy: "||")
        
        /* [
            [name: "loyalty", types: ["SLOTTED", "BONUS"],
            [name: "sale", types: ["PRIORITY_ACCESS", "REDUCED"]
         ] */
        self.availableBadges = availableBadgesArray.map{
            let components = $0.split(separator: ":")
            return Badge(name: String(components[0]), types: components[1].components(separatedBy: ","))
        }
        
    }
    
}

struct Badge: Codable {
    let name: String
    let types: [String]
}

struct Offer: Codable {
    let id: String
    let title: String
    let type: String
}
