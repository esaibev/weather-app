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
    var approvedTime: String?
    var dailyForecast: [DailyForecast] = []

    struct DailyForecast {
        let date: String
        let maxTemperature: Double
        let symbol: WeatherSymbol
    }

//    private func processData() {
//        guard let timeSeries = weatherData?.timeSeries else { return }
//
//        let groupedByDay = Dictionary(grouping: timeSeries, by: { $0.validTime.prefix(10) }) // Group by day
//
//        dailyForecast = groupedByDay.map { day, entries in
//            let maxTempEntry = entries.max { a, b in
//                a.temperature < b.temperature
//            }
//
//            let date = String(day)
//            let maxTemp = maxTempEntry?.temperature ?? 0
//            let symbol = maxTempEntry?.weatherSymbol ?? .clearSky // Default to clearSky if no data
//
//            return DailyForecast(date: date, maxTemperature: maxTemp, symbol: symbol)
//        }
//    }

//    private func processData() {
//        dailyForecast = []
//        guard let timeSeries = weatherData?.timeSeries else { return }
//
//        for period in timeSeries {
//            let date = String(period.validTime.prefix(10)) // Extract the first ten characters from the date (YYYY-MM-DD)
//            let temp = period.temperature
//            let symbolValue = period.weatherSymbolValue
//            let symbol = WeatherSymbol(rawValue: Int(symbolValue)) ?? .clearSky
//
//            dailyForecast.append(DailyForecast(date: date, maxTemperature: temp, symbol: symbol))
//        }
//    }

//    private func processForecasts() {
//        dailyForecast = []
//        guard let timeSeries = weatherData?.timeSeries else { return }
//
//        approvedTime = weatherData?.approvedTime
//
//        var currentDay = ""
//        var maxTempForDay: Double = -100
//        var symbolForDay: WeatherSymbol = .clearSky
//
//        for period in timeSeries {
//            let date = String(period.validTime.prefix(10)) // Extract YYYY-MM-DD
//            let temp = period.temperature
//            let symbolValue = period.weatherSymbolValue
//            let symbol = WeatherSymbol(rawValue: Int(symbolValue)) ?? .clearSky
//
//            if date != currentDay {
//                if !currentDay.isEmpty {
//                    // Append the forecast for the previous day
//                    dailyForecast.append(DailyForecast(date: currentDay, maxTemperature: maxTempForDay, symbol: symbolForDay))
//                }
//                // Reset for new day
//                currentDay = date
//                maxTempForDay = temp
//                symbolForDay = symbol
//            } else {
//                // Update max temperature if higher
//                if temp > maxTempForDay {
//                    maxTempForDay = temp
//                    symbolForDay = symbol
//                }
//            }
//        }
//
//        // Append the last day's forecast
//        if !currentDay.isEmpty {
//            dailyForecast.append(DailyForecast(date: currentDay, maxTemperature: maxTempForDay, symbol: symbolForDay))
//        }
//
//        print(dailyForecast)
//    }

    private func processForecasts() {
        dailyForecast = []
        guard let timeSeries = weatherData?.timeSeries, !timeSeries.isEmpty else { return }

        // Set the approvedTime
        approvedTime = weatherData?.approvedTime

        // Process the first time period
        var currentDay = String(timeSeries.first!.validTime.prefix(10))
        var maxTempForDay = timeSeries.first!.temperature
        var symbolForDay = WeatherSymbol(rawValue: Int(timeSeries.first!.weatherSymbolValue)) ?? .clearSky

        // Start processing from the second time period
        for period in timeSeries.dropFirst() {
            let date = String(period.validTime.prefix(10)) // Extract YYYY-MM-DD
            let temp = period.temperature
            let symbolValue = period.weatherSymbolValue
            let symbol = WeatherSymbol(rawValue: Int(symbolValue)) ?? .clearSky

            if date != currentDay {
                // Append the forecast for the previous day
                dailyForecast.append(DailyForecast(date: currentDay, maxTemperature: maxTempForDay, symbol: symbolForDay))
                
                // Reset for new day
                currentDay = date
                maxTempForDay = temp
                symbolForDay = symbol
            } else if temp > maxTempForDay {
                // Update max temperature if higher
                maxTempForDay = temp
                symbolForDay = symbol
            }
        }

        // Append the last day's forecast
        dailyForecast.append(DailyForecast(date: currentDay, maxTemperature: maxTempForDay, symbol: symbolForDay))

        print(dailyForecast)
    }

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
                processForecasts()
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
