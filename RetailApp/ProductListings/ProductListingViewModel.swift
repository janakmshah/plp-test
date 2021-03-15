//
//  ProductListingViewModel.swift
//  RetailApp
//
//  Created by Janak Shah on 15/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import UIKit

class ProductListingViewModel {
    
    let title: Observable<String>
    let price: Observable<NSAttributedString>
    let badge: Observable<UIImage?>
    let image: Observable<UIImage?>
    
    private let priceFormatter: PriceFormatter
    private let imageService: ImageService
    
    init(displayDetails: ProductCellDisplayable,
         imageService: ImageService = ImageServiceImplementation(api: API.defaultAPI),
         priceFormatter: PriceFormatter = PriceFormatterImplementation()) {
        
        self.priceFormatter = priceFormatter
        self.imageService = imageService
        self.price = Observable<NSAttributedString>(displayDetails.price)
        self.title = Observable<String>("")
        self.image = Observable<UIImage?>(ImageCache.fetch(for: displayDetails.imageKey) ?? #imageLiteral(resourceName: "Placeholder"))
        self.badge = Observable<UIImage?>(nil)
        
        //downloadImage(key: displayDetails.imageKey, for: image)
        
        guard let badgeKey = displayDetails.badgeKey else {
            badge.value = nil
            return
        }
        downloadImage(key: badgeKey + "_icon", for: badge)
    }
    
    private func downloadImage(key: String, for observable: Observable<UIImage?>) {
        imageService.downloadImage(key: key) { result in
            if let image = try? result.unwrapped() {
                observable.value = image
            }
        }
    }
    
}
