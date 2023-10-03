//
//  NetworkingManager.swift
//  SUWeather
//
//  Created by Doni on 04/08/23.
//

import Foundation
import Alamofire

struct NetworkingManager {
    
    private let apiKey = "0c0d069ceedcc1fbe9ac6dc014103a01"
    private let basePath = "https://api.openweathermap.org/data/2.5/weather?"
    private let cacheManager = CacheManager()
    
    func fetchWeatherCity(byCity city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
        let cityPath = basePath + "q=%@&appid=%@&units=metric"
        let urlString = String(format: cityPath, query, apiKey)
        handleRequest(urlString: urlString, completion: completion)
    }
    
    func fetchWeatherLocation(lat: Double, lon: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let locationPath = basePath + "appid=%@&units=metric&lat=%f&lon=%f"
        let urlString = String(format: locationPath, apiKey, lat, lon)
        handleRequest(urlString: urlString, completion: completion)
    }
    
    private func handleRequest(urlString: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        AF.request(urlString)
            .validate()
            .responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { response in
            switch response.result {
            case .success(let weatherData):
                completion(.success(weatherData))
                self.cacheManager.cacheCity(cityName: weatherData.name)
            case .failure(let error):
                if let err = self.getWeatherError(error: error, data: response.data) {
                    completion(.failure(err))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func getWeatherError(error: AFError, data: Data?) -> Error? {
        if error.responseCode == 404,
           let data = data,
           let failure = try? JSONDecoder().decode(ErrorDataFailure.self, from: data) {
           let message = failure.message
           return CustomError.custom(description: message)
        } else {
            return nil
        }
    }
}
