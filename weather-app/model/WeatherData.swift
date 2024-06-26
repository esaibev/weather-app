//
//  WeatherForecastData.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-20.
//

import Foundation
import SwiftUI

// Represents the weather data
struct WeatherData: Codable {
    var approvedTime: String // Time the forecast was last updated
    var referenceTime: String // Forecast start time
    var geometry: Geometry // Forecast location
    var timeSeries: [TimePeriod] // Array of time periods for the 10-day forecast
}

// Represents the location of the weather data
struct Geometry: Codable {
    var type: String
    var coordinates: [[Double]]
}

// Represents the coordinates
struct Coordinates: Codable {
    var lat: Double
    var lon: Double
}

// Represents each time period in the weather data
struct TimePeriod: Codable {
    var validTime: String // Specific time for this data
    var parameters: [WeatherParameter] // Array of different weather parameters
}

extension TimePeriod {
    var temperature: Double {
        parameters.first { $0.name == "t" }?.values.first ?? 0
    }

    var weatherSymbolValue: Double {
        parameters.first { $0.name == "Wsymb2" }?.values.first ?? 0
    }
}

// Represents each weather parameter
struct WeatherParameter: Codable {
    var name: String // Name of the parameter
    var values: [Double] // Values for the parameter

    enum CodingKeys: String, CodingKey {
        case name, values
    }
}

// Represents functions on WeatherData
extension WeatherData {
    func process(with locationInput: String) -> Forecast {
        guard !timeSeries.isEmpty else { return Forecast(approvedTime: formatDate(approvedTime), locationInput: "", coordinates: Coordinates(lat: 59.33, lon: 18.07), hourly: [], daily: [], isFavorite: false) }

        let hourlyForecasts = processHourlyForecasts()
        let dailyForecasts = processDailyForecasts()

        let coordinates = geometry.coordinates.first.map { Coordinates(lat: $0[1], lon: $0[0]) }
            ?? Coordinates(lat: 59.33, lon: 18.07) // Fallback coordinates for Stockholm if not found

        return Forecast(approvedTime: formatDate(approvedTime), locationInput: locationInput, coordinates: coordinates, hourly: hourlyForecasts, daily: dailyForecasts, isFavorite: false)
    }

    private func processHourlyForecasts() -> [Forecast.Hourly] {
        var hourlyForecasts: [Forecast.Hourly] = []

        for period in timeSeries.prefix(24) {
            let dateString = period.validTime

            let time = String(dateString.split(separator: "T")[1].prefix(2)) // Extracts the "HH" part
            let temperature = period.temperature
            let symbol = WeatherSymbol(rawValue: Int(period.weatherSymbolValue)) ?? .clearSky

            let hourlyForecast = Forecast.Hourly(time: time, temperature: temperature, symbol: symbol)
            hourlyForecasts.append(hourlyForecast)
        }

        return hourlyForecasts
    }

    private func processDailyForecasts() -> [Forecast.Daily] {
        var dailyForecasts: [Forecast.Daily] = []

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
                dailyForecasts.append(Forecast.Daily(date: currentDay, maxTemperature: maxTempForDay, symbol: symbolForDay))

                // Reset for new day
                currentDay = date
                maxTempForDay = temp // Set maxTempForDay to the first temp of the day
                symbolForDay = symbol
            } else if temp > maxTempForDay {
                // Update max temperature if higher
                maxTempForDay = temp
                symbolForDay = symbol
            }
        }

        // Append the last day's forecast
        dailyForecasts.append(Forecast.Daily(date: currentDay, maxTemperature: maxTempForDay, symbol: symbolForDay))

        return dailyForecasts
    }

    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // POSIX for fixed format

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString // Return original string if parsing fails
        }
    }
}
