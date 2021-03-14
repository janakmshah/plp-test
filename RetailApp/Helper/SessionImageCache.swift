//
//  SessionImageCache.swift
//  RetailApp
//
//  Created by Janak Shah on 14/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import UIKit

// Reduced uneccesary image requests
struct ImageCache {
    
    // Cleared on app quit
    static var session = [String: UIImage]()
    
    static func fetch(for id: String) -> UIImage? {
        
        // Check session cache
        return session[id]
        
    }
    
    static func cache(_ image: UIImage, for id: String) {
        
        // Write to session cache
        session[id] = image
        
    }
    
}
