//
//  OffersService.swift
//  RetailApp
//
//  Created by Janak Shah on 13/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import Foundation

protocol OffersService {
    func getOffers(for userId: String, completion: @escaping (Result<UserOffers, Error>) -> Void)
}

class OffersServiceImplementation: OffersService {
    private let api: API
    
    init(api: API) {
        self.api = api
    }
    
    func getOffers(for userId: String, completion: @escaping (Result<UserOffers, Error>) -> Void) {
        let resource = Resource<UserOffers>(path: "api/user/\(userId)/offers")
        api.load(resource, completion: completion)
    }
    
}
