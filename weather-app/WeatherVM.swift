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
    var forecast: Forecast = .init(approvedTime: "", locationInput: "", coordinates: Coordinates(lat: 59.33, lon: 18.07), hourly: [], daily: [], isFavorite: false)
    var favoriteForecasts: [Forecast] = []
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
        isConnected = await WeatherNetworkService.isConnectedToInternet()
        if isConnected {
            do {
                let coordinates = try await WeatherNetworkService.getCoordinates(for: location)
                let forecast = try await WeatherNetworkService.getForecast(for: coordinates, locationInput: location)
                updateForecast(forecast)
                print("Forecast fetch successful for coordinates")
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    print("Error getting weather for location: \(error.localizedDescription)")
                }
            }
        }
    }

    private func getWeatherAtCoordinates(_ coordinates: Coordinates) async {
        do {
            let forecast = try await WeatherNetworkService.getForecast(for: coordinates, locationInput: forecast.locationInput)
            updateForecast(forecast)
            print("Forecast fetch successful for coordinates")
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                print("Error getting weather for location: \(error.localizedDescription)")
            }
        }
    }

    func getWeatherForFavorite(_ forecast: Forecast) async {
        isConnected = await WeatherNetworkService.isConnectedToInternet()
        if isConnected {
            do {
                let forecast = try await WeatherNetworkService.getForecast(for: forecast.coordinates, locationInput: forecast.locationInput)
                updateForecast(forecast)
                print("Forecast fetch successful for favorite location")
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    print("Error getting weather for favorite location: \(error.localizedDescription)")
                }
            }
        } else {
            updateForecast(forecast)
        }
    }

    private func updateForecast(_ newForecast: Forecast) {
        DispatchQueue.main.async {
            self.hasData = true
            self.forecast = newForecast
            self.updateFavoriteStatusOfForecast()
            self.forecast.updateSelfInFavorites(&self.favoriteForecasts)
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
            favoriteForecasts = try await Forecast.loadFavorites()
            updateFavoriteStatusOfForecast()

            print("Forecast data loaded successfully")
            return true
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to load forecast data")
            return false
        }
    }

    func toggleFavorite() {
        if forecast.isFavorite(favoriteForecasts) {
            forecast.removeFavorite(from: &favoriteForecasts)
        } else {
            forecast.addFavorite(to: &favoriteForecasts)
        }
    }

    func updateFavoriteStatusOfForecast() {
        if forecast.isFavorite(favoriteForecasts) {
            forecast.setFavorite()
        }
        print("Status: \(forecast.isFavorite)")
    }

    func saveFavorites() async {
        do {
            try await Forecast.saveFavorites(favoriteForecasts)
            print("Favorite forecasts saved")
        } catch {
            print("Failed to save favorite forecasts: \(error)")
        }
    }

    /// Only used for previews
    convenience init(sampleData: Forecast, sampleFavorites: [Forecast]) {
        self.init()
        self.forecast = sampleData
        self.favoriteForecasts = sampleFavorites
    }
}
