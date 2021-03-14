//
//  User.swift
//  RetailApp
//
//  Created by Janak Shah on 14/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import Foundation

struct User {
    
    let userOffers: UserOffers
    let id = "5"
    
    static var current = User(userOffers: UserOffers())
    
}
