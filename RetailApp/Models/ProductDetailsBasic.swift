//
//  ProductDetailsBasic.swift
//  RetailApp
//
//  Created by Janak Shah on 13/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import Foundation

/*
 Though the majority of these properties are shared with the ProductDetails model,
 I decided to keep the two models separate because if once of the responses changes,
 it won't affect components where the other model is implemented
 */
struct ProductDetailsBasic: Codable, ProductRequest {
    let id: String
    let name: String
    let imageKey: String
    let price: Price
    let offerIds: [String]
}
