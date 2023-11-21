//
//  WeatherVM.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-20.
//

import Foundation

@Observable
class WeatherVM {
    @ObservationIgnored private var weatherData: WeatherData?
    var errorMessage: String?

    func fetchWeather() {
        WeatherNetworkService.fetchWeatherData { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.weatherData = data
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
