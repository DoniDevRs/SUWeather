//
//  SUWeatherApp.swift
//  SUWeather
//
//  Created by Doni on 04/08/23.
//

import SwiftUI

@main
struct SUWeatherApp: App {
    
    @StateObject var wheaterViewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            WeatherView().environmentObject(wheaterViewModel)
        }
    }
}
