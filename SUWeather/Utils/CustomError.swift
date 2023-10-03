//
//  CustomError.swift
//  SUWeather
//
//  Created by Doni on 04/08/23.
//

import Foundation

enum CustomError: Error, LocalizedError {
    case custom(description: String)
    
    var errorDescription: String? {
        switch self {
        case .custom(let description):
            return description
        }
    }
}

struct ErrorDataFailure: Decodable {
    let message: String
}
