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

    func getWeather() async {
        WeatherNetworkService.isConnectedToInternet { isConnected in
            DispatchQueue.main.async {
                if isConnected {
                    self.fetchNewWeather()
                } else {
                    Task {
                        await self.loadWeatherData()
                        self.errorMessage = "No internet connection. Using saved data."
                    }
                }
            }
        }
    }

    private func fetchNewWeather() {
        WeatherNetworkService.fetchWeatherData { [weak self] result in
            switch result {
            case .success(let data):
                print("Weather fetch successful")
                DispatchQueue.main.async {
                    self?.weatherData = data
                }
            case .failure(let error):
                print("Weather fetch failed")
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
