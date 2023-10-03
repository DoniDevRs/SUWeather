//
//  WeatherViewModel.swift
//  SUWeather
//
//  Created by Doni on 04/08/23.
//

import Foundation
import CoreLocation

final class WeatherViewModel: NSObject, ObservableObject {
    
    @Published var showChangeCityView: Bool = false
    @Published var cityName: String = "City"
    @Published var temperature: Int = 0
    @Published var imageCenter: String = "imClouds"
    @Published var conditionDescription: String = ""
    @Published var messageStatus: String = "Condition"
    @Published var isNight: Bool = false
    
    private let weatherManager = NetworkingManager()
    private let cacheManager = CacheManager()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    func getWeather(byCity city: String) {
        weatherManager.fetchWeatherCity(byCity: city) { result in
            self.handleResult(result)
        }
    }
    
    func getWeatherByLocation(byLocation location: CLLocation) {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        weatherManager.fetchWeatherLocation(lat: lat, lon: lon) { result in
            self.handleResult(result)
        }
    }
    
    func getCurrentLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        default:
            locationManager.requestLocation()
        }
    }
    
    private func handleResult(_ result: Result<WeatherData, Error>) {
        switch result {
        case .success(let data):
            messageStatus = MessageStatus.success.rawValue
            updateView(with: data)
        case .failure(let error):
            messageStatus = "\(MessageStatus.failure.rawValue) \(error.localizedDescription)"
        }
    }
    
    private func updateView(with data: WeatherData) {
        cityName = data.name
        temperature = data.main.temp.toInt()
        imageCenter = getImageFromId(data)
        conditionDescription = data.weather.first?.description.capitalized ?? ""
    }
    
    private func getImageFromId(_ data: WeatherData) -> String {
        switch data.weather.first!.id {
        case 200...299:
            return "imThunderstorm"
        case 300...399:
            return "imDrizzle"
        case 500...599:
            return "imRain"
        case 600...699:
            return "imSnow"
        case 700...799:
            return "imAtmosphere"
        case 800:
            return "imClear"
        default:
            return "imClouds"
        }
    }
}

extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            getWeatherByLocation(byLocation: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        messageStatus = "\(MessageStatus.failure.rawValue) \(error.localizedDescription)"
    }
}
