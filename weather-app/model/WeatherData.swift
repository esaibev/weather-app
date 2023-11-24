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
    private(set) var lat: Double
    private(set) var lon: Double
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
    func process() -> Forecast {
        guard !timeSeries.isEmpty else { return Forecast(approvedTime: formatDate(approvedTime), daily: []) }

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

        return Forecast(approvedTime: formatDate(approvedTime), daily: dailyForecasts)
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
