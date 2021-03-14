//
//  SessionImageCache.swift
//  RetailApp
//
//  Created by Janak Shah on 14/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import UIKit

// Reducing uneccesary image requests
struct ImageCache {

    static private let concurrentImageCacheQueue = DispatchQueue(label: "com.marksandspencer.technical-test.RetailApp.image.cache.queue", attributes: .concurrent)
    
    // Cleared on app quit
    static private var session = [String: UIImage]()
    
    static internal func fetch(for id: String) -> UIImage? {
        // Check session cache
        concurrentImageCacheQueue.sync {
            return session[id]
        }
    }
    
    static internal func cache(_ image: UIImage, for id: String) {
        // Write to session cache
        concurrentImageCacheQueue.async(flags: .barrier) {
            session[id] = image
        }
    }
    
}
