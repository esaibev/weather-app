//
//  WeatherVM.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-20.
//

import Foundation
import Observation

@Observable
class WeatherVM {
    var errorMessage: String?
    var forecast: Forecast = .init(approvedTime: "", daily: [])

    func getWeatherForLocation(_ location: String) async {
        do {
            let coordinates = try await WeatherNetworkService.getCoordinates(for: location)
            print(coordinates)
            let forecast = try await WeatherNetworkService.getForecast(for: coordinates)
            DispatchQueue.main.async {
                self.forecast = forecast
                print("Forecast fetch successful for coordinates")
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                print("Error getting weather for location: \(error.localizedDescription)")
            }
        }
    }

    func getWeather() async {
        WeatherNetworkService.isConnectedToInternet { isConnected in
            DispatchQueue.main.async {
                if isConnected {
                    self.fetchNewWeather()
                } else {
                    Task {
                        await self.loadForecast()
                        self.errorMessage = "No internet connection. Using saved data."
                    }
                }
            }
        }
    }

    private func fetchNewWeather() {
        WeatherNetworkService.fetchForecastData { [weak self] result in
            switch result {
            case .success(let forecast):
                DispatchQueue.main.async {
                    self?.forecast = forecast
                    print("Forecast fetch successful")
                }
            case .failure(let error):
                print("Forecast fetch failed")
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func saveForecast() async {
        do {
            try await Forecast.save(forecast)
            print("Forecast data saved")
        } catch {
            errorMessage = error.localizedDescription
            print("Forecast data not saved")
        }
    }

    func loadForecast() async {
        do {
            forecast = try await Forecast.load()
            print("Forecast data loaded successfully")
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to load forecast data")
        }
    }

    /// Only used for previews
    convenience init(sampleData: Forecast) {
        self.init()
        self.forecast = sampleData
    }
}
