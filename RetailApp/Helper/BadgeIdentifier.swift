//
//  BadgeIdentifier.swift
//  RetailApp
//
//  Created by Janak Shah on 15/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import Foundation

struct BadgeIdentifer {
    
    static func badgeToDisplay(userOffers: UserOffers, offerIds: [String]) -> String? {
                
        let matchingOffers = userOffers.offers.filter { offerIds.contains($0.id) }
        
        let displayOffer = userOffers.availableBadges.first { badge -> Bool in
            
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
