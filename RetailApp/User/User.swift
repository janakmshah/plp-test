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
    
    static var current = User(userOffers: UserOffers())
    
    // A var (rather than a let) to support switching users and logging out
    var username: String {
        "admin"
    }
    
    // A var (rather than a let) to support switching users and logging out
    var password: String {
        "password"
    }
    
    // A var (rather than a let) to support switching users and logging out
    var id: String {
        // "1" || "2" || "3" || "4" || "5"
        "5"
    }
    
}
