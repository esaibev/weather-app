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
    @ObservationIgnored private var weatherData: WeatherData?
    var errorMessage: String?
    var forecast: Forecast?

    private func processForecasts() {
        guard let weatherData = weatherData else { return }
        forecast = weatherData.process()
        print(forecast!)
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
        WeatherNetworkService.fetchWeatherData { [weak self] result in
            switch result {
            case .success(let data):
                print("Weather fetch successful")
                DispatchQueue.main.async {
                    self?.weatherData = data
                    self?.processForecasts()
//                    print("\(self?.weatherData)")
                }
            case .failure(let error):
                print("Weather fetch failed")
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func saveForecast() async {
        guard let forecast = forecast else { return }
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
            print(forecast!)
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to load forecast data")
        }
    }
}
