//
//  WeatherForecastData.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-20.
//

import Foundation

// Represents the weather data
struct WeatherData: Codable {
    var approvedTime: String // Time the forecast was last updated
    var referenceTime: String // Forecast start time
    var geometry: Geometry // Forecast location
    var timeSeries: [TimePeriod] // Array of time periods for the 7-day forecast

    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
            .appendingPathComponent("weatherData.data")
    }

    static func load() async throws -> WeatherData {
        let fileURL = try fileURL()
        guard let data = try? Data(contentsOf: fileURL) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data available"])
        }
        return try JSONDecoder().decode(WeatherData.self, from: data)
    }

    static func save(_ weatherData: WeatherData) async throws {
        let data = try JSONEncoder().encode(weatherData)
        let outfile = try fileURL()
        try data.write(to: outfile)
    }
}

// Represents the location of the weather data
struct Geometry: Codable {
    var type: String
    var coordinates: [[Double]]
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

// Enum for weather symbols (Wsymb2) with associated meanings
enum WeatherSymbol: Int, Codable {
    case clearSky = 1
    case nearlyClearSky = 2
    case variableCloudiness = 3
    case halfclearSky = 4
    case cloudySky = 5
    case overcast = 6
    case fog = 7
    case lightRainShowers = 8
    case moderateRainShowers = 9
    case heavyRainShowers = 10
    case thunderstorm = 11
    case lightSleetShowers = 12
    case moderateSleetShowers = 13
    case heavySleetShowers = 14
    case lightSnowShowers = 15
    case moderateSnowShowers = 16
    case heavySnowShowers = 17
    case lightRain = 18
    case moderateRain = 19
    case heavyRain = 20
    case thunder = 21
    case lightSleet = 22
    case moderateSleet = 23
    case heavySleet = 24
    case lightSnowfall = 25
    case moderateSnowfall = 26
    case heavySnowfall = 27

    var description: String {
        switch self {
        case .clearSky: return "Clear sky"
        case .nearlyClearSky: return "Nearly clear sky"
        // TODO: Add descriptions for all cases
        default: return "Unknown"
        }
    }

    var iconName: String {
        switch self {
        case .clearSky: return "sun.max"
        case .lightRainShowers: return "cloud.drizzle"
        // ... map other cases ...
        default: return "questionmark"
        }
    }
}
