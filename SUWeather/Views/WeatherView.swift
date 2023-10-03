//
//  WeatherView.swift
//  SUWeather
//
//  Created by Doni on 04/08/23.
//

import Foundation
import SwiftUI

struct WeatherView: View {
    
    // MARK: - PROPERTIES
    @State private var defaultCity = "New York"
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    // MARK: - MANAGERS
    private let cacheManager = CacheManager()
    private let weatherManager = NetworkingManager()
    
    // MARK: - UI
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(isNight: weatherViewModel.isNight)
                VStack(alignment: .center, spacing: 2) {
                    Spacer()
                    CustomTextView(text: weatherViewModel.cityName)
                    
                    ImageTempSatusView(imageName: weatherViewModel.imageCenter,
                                         temperature: weatherViewModel.temperature)
                    
                    CustomTextView(text: weatherViewModel.conditionDescription)
                    Spacer()
                    Button {
                        withAnimation {
                            weatherViewModel.showChangeCityView = true
                        }
                    } label: {
                        CustomButton(title: "Change City",
                                     textColor: .blue,
                                     backgroundColor: .white)
                    }
                    Spacer()
                }
            }.onAppear {
                let city = cacheManager.getCacheCity() ?? defaultCity
                weatherViewModel.getWeather(byCity: city)
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        weatherViewModel.getCurrentLocation()
                    } label: {
                        Image(systemName: "location.circle.fill").tint(.white)
                    }
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        weatherViewModel.isNight.toggle()
                    } label: {
                        Image(systemName: "lightswitch.off").tint(.white)
                    }
                }
            })
            .sheet(isPresented: $weatherViewModel.showChangeCityView) {
                ChangeCityView()
            }
        }
    }
}
