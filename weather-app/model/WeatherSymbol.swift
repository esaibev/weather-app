//
//  WeatherSymbol.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-22.
//

import SwiftUI

// Enum for weather symbols (Wsymb2) with associated icon names
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
        case .clearSky: return "Clear Sky"
        case .nearlyClearSky: return "Nearly Clear Sky"
        case .variableCloudiness: return "Variable Cloudiness"
        case .halfclearSky: return "Partly Cloudy"
        case .cloudySky: return "Cloudy Sky"
        case .overcast: return "Overcast"
        case .fog: return "Fog"
        case .lightRainShowers: return "Light Rain Showers"
        case .moderateRainShowers: return "Moderate Rain Showers"
        case .heavyRainShowers: return "Heavy Rain Showers"
        case .thunderstorm: return "Thunderstorm"
        case .lightSleetShowers: return "Light Sleet Showers"
        case .moderateSleetShowers: return "Moderate Sleet Showers"
        case .heavySleetShowers: return "Heavy Sleet Showers"
        case .lightSnowShowers: return "Light Snow Showers"
        case .moderateSnowShowers: return "Moderate Snow Showers"
        case .heavySnowShowers: return "Heavy Snow Showers"
        case .lightRain: return "Light Rain"
        case .moderateRain: return "Moderate Rain"
        case .heavyRain: return "Heavy Rain"
        case .thunder: return "Thunder"
        case .lightSleet: return "Light Sleet"
        case .moderateSleet: return "Moderate Sleet"
        case .heavySleet: return "Heavy Sleet"
        case .lightSnowfall: return "Light Snowfall"
        case .moderateSnowfall: return "Moderate Snowfall"
        case .heavySnowfall: return "Heavy Snowfall"
        }
    }

    var iconName: String {
        switch self {
        case .clearSky: return "sun.max"
        case .nearlyClearSky: return "sun.max.fill"
        case .variableCloudiness: return "cloud.sun"
        case .halfclearSky: return "cloud.sun.fill"
        case .cloudySky: return "cloud"
        case .overcast: return "smoke.fill"
        case .fog: return "cloud.fog"
        case .lightRainShowers: return "cloud.drizzle"
        case .moderateRainShowers: return "cloud.rain"
        case .heavyRainShowers: return "cloud.heavyrain"
        case .thunderstorm: return "cloud.bolt.rain"
        case .lightSleetShowers: return "cloud.sleet"
        case .moderateSleetShowers: return "cloud.hail"
        case .heavySleetShowers: return "cloud.hail.fill"
        case .lightSnowShowers: return "cloud.snow"
        case .moderateSnowShowers: return "snow"
        case .heavySnowShowers: return "wind.snow"
        case .lightRain: return "cloud.drizzle.fill"
        case .moderateRain: return "cloud.rain.fill"
        case .heavyRain: return "cloud.heavyrain.fill"
        case .thunder: return "cloud.bolt"
        case .lightSleet: return "cloud.sleet.fill"
        case .moderateSleet: return "cloud.hail"
        case .heavySleet: return "cloud.hail.fill"
        case .lightSnowfall: return "cloud.snow.fill"
        case .moderateSnowfall: return "snow"
        case .heavySnowfall: return "wind.snow"
        }
    }
}
