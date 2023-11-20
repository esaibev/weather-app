//
//  WeatherVM.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-20.
//

import Foundation

class WeatherVM: ObservableObject {
    private var weatherData: WeatherData?
    @Published var errorMessage: String?

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
