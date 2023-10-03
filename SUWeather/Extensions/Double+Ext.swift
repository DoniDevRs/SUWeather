//
//  Double+Ext.swift
//  SUWeather
//
//  Created by Doni on 04/08/23.
//

import Foundation

extension Double {
    func toString() -> String {
        return String(format: "%1.f", self)
    }
    
    func toInt() -> Int {
        return Int(self)
    }
}
