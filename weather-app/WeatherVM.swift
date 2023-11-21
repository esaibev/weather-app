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

    func saveWeatherData() async {
        guard let weatherData = weatherData else { return }
        do {
            try await WeatherData.save(weatherData)
            print("Weather data saved")
        } catch {
            errorMessage = error.localizedDescription
            print("Weather data not saved")
        }
    }

    func loadWeatherData() async {
        do {
            weatherData = try await WeatherData.load()
            if weatherData != nil {
                print("Weather data loaded successfully")
//                print("\(weatherData)")
            } else {
                print("No weather data available")
            }
        } catch {
            errorMessage = error.localizedDescription

            // For testing: Save some sample data if loading fails
            weatherData = WeatherData(approvedTime: "2023-11-20T13:00:00Z",
                                      referenceTime: "2023-11-20T13:00:00Z",
                                      geometry: Geometry(type: "Point", coordinates: [[14.333, 60.383]]),
                                      timeSeries: [])
            Task {
                await saveWeatherData()
                print("Sample weather data saved.")
            }
        }
    }
}
