//
//  User.swift
//  RetailApp
//
//  Created by Janak Shah on 14/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import Foundation

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
        self.availableBadges = availableBadgesArray.map {
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
