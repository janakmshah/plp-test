//
//  ProductListingViewModel.swift
//  RetailApp
//
//  Created by Janak Shah on 15/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import UIKit

protocol ProductCellDisplayable {
    var title: String { get }
    var imageKey: String { get }
    var price: NSAttributedString { get }
    var offerIds: [String] { get }
}

struct ProductCellDisplayableImplementation: ProductCellDisplayable {
    let title: String
    let imageKey: String
    let price: NSAttributedString
    let offerIds: [String]
}

class ProductListingViewModel {
    
    // MARK: - Properties
    
    let title: Observable<String>
    let price: Observable<NSAttributedString>
    let badge: Observable<UIImage?>
    let image: Observable<UIImage?>
    
    private let priceFormatter: PriceFormatter
    private let imageService: ImageService
    
    // MARK: - Initialisers
    
    init(displayDetails: ProductCellDisplayable,
         imageService: ImageService = ImageServiceImplementation(api: API.defaultAPI),
         priceFormatter: PriceFormatter = PriceFormatterImplementation()) {
        
        self.priceFormatter = priceFormatter
        self.imageService = imageService
        self.price = Observable<NSAttributedString>(displayDetails.price)
        self.title = Observable<String>("")
        self.image = Observable<UIImage?>(ImageCache.fetch(for: displayDetails.imageKey) ?? #imageLiteral(resourceName: "Placeholder"))
        self.badge = Observable<UIImage?>(nil)
        
        downloadImage(key: displayDetails.imageKey, for: image)
        
        guard let badgeKey = badgeToDisplay(offerIds: displayDetails.offerIds) else {
            badge.value = nil
            return
        }
        downloadImage(key: badgeKey + "_icon", for: badge)
    }
    
    // MARK: - Fetch data
    
    private func downloadImage(key: String, for observable: Observable<UIImage?>) {
        imageService.downloadImage(key: key) { result in
            switch result {
            case .value(let value):
                observable.value = value
            case .error(let error):
                debugPrint(error)
            }
        }
    }
    
    // MARK: - Helpers
    
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
