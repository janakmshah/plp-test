//
//  ProductsService.swift
//  RetailApp
//
//  Created by Janak Shah on 13/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import Foundation

protocol ProductsService {
    func getProducts(completion: @escaping (Result<ProductDetailsBasic, Error>) -> Void)
}

class ProductsServiceImplementation: ProductsService {
    private let api: API
    
    init(api: API) {
        self.api = api
    }
    
    func getProducts(completion: @escaping (Result<ProductDetailsBasic, Error>) -> Void) {
        let resource = Resource<ProductDetailsBasic>(path: "api/products")
        api.load(resource, completion: completion)
    }
    
}
