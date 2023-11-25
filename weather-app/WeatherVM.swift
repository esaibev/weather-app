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
    var forecast: Forecast = .init(approvedTime: "", locationInput: "", coordinates: Coordinates(lat: 59.33, lon: 18.07), daily: [])
    var isConnected = false
    var hasData = false

    init() {
        Task {
            self.isConnected = await WeatherNetworkService.isConnectedToInternet()
            if await loadForecast() {
                self.hasData = true
                if isConnected {
                    let coordinates = forecast.coordinates
                    await getWeatherAtCoordinates(coordinates)
                }
            }
        }
    }

    func getWeatherForLocation(_ location: String) async {
        do {
            let coordinates = try await WeatherNetworkService.getCoordinates(for: location)
            print(coordinates)
            let forecast = try await WeatherNetworkService.getForecast(for: coordinates, locationInput: location)
            DispatchQueue.main.async {
                self.hasData = true
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

    private func getWeatherAtCoordinates(_ coordinates: Coordinates) async {
        do {
            let forecast = try await WeatherNetworkService.getForecast(for: coordinates, locationInput: forecast.locationInput)
            DispatchQueue.main.async {
                self.hasData = true
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

    func saveForecast() async {
        do {
            try await Forecast.save(forecast)
            print("Forecast data saved")
        } catch {
            errorMessage = error.localizedDescription
            print("Forecast data not saved")
        }
    }

    func loadForecast() async -> Bool {
        do {
            forecast = try await Forecast.load()
            print("Forecast data loaded successfully")
            return true
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to load forecast data")
            return false
        }
    }

    /// Only used for previews
    convenience init(sampleData: Forecast) {
        self.init()
        self.forecast = sampleData
    }
}
