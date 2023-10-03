//
//  CacheManager.swift
//  SUWeather
//
//  Created by Doni on 04/08/23.
//

import Foundation

struct CacheManager {
    
    private let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case city
    }
    
    func cacheCity(cityName: String) {
        userDefaults.set(cityName, forKey: Key.city.rawValue)
    }
    
    func getCacheCity() -> String? {
        return userDefaults.value(forKey: Key.city.rawValue) as? String
    }
}
