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
}

// Represents the location of the weather data
struct Geometry: Codable {
    var type: String
    var coordinates: [[Double]]
}

// Represents each time period in the weather data
struct TimePeriod: Codable {
    var validTime: String /// Specific time for this data
    var parameters: [WeatherParameter] // Array of different weather parameters
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
}
