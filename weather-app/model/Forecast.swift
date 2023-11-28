//
//  Forecast.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-22.
//

import Foundation

struct Forecast: Codable, Identifiable {
    private(set) var id = UUID()
    private(set) var approvedTime: String
    private(set) var locationInput: String
    private(set) var coordinates: Coordinates
    private(set) var hourly: [Hourly]
    private(set) var daily: [Daily]
    private(set) var isFavorite: Bool

    struct Hourly: Codable, Identifiable {
        let id: UUID
        let time: String
        let temperature: Double
        let symbol: WeatherSymbol

        init(id: UUID = UUID(), time: String, temperature: Double, symbol: WeatherSymbol) {
            self.id = id
            self.time = time
            self.temperature = temperature
            self.symbol = symbol
        }
    }

    struct Daily: Codable, Identifiable {
        let id: UUID
        let date: String
        let maxTemperature: Double
        let symbol: WeatherSymbol

        init(id: UUID = UUID(), date: String, maxTemperature: Double, symbol: WeatherSymbol) {
            self.id = id
            self.date = date
            self.maxTemperature = maxTemperature
            self.symbol = symbol
        }
    }
}

// Represents persistency functions on active forecast
extension Forecast {
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
            .appendingPathComponent("forecast.data")
    }

    static func load() async throws -> Forecast {
        let fileURL = try fileURL()
        guard let data = try? Data(contentsOf: fileURL) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data available"])
        }
        return try JSONDecoder().decode(Forecast.self, from: data)
    }

    static func save(_ forecast: Forecast) async throws {
        let data = try JSONEncoder().encode(forecast)
        let outfile = try fileURL()
        try data.write(to: outfile)
    }
}

// Represents persistency functions on favorite forecasts
extension Forecast {
    private static func favoritesFileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
            .appendingPathComponent("favoriteForecasts.data")
    }

    static func loadFavorites() async throws -> [Forecast] {
        let fileURL = try favoritesFileURL()
        guard let data = try? Data(contentsOf: fileURL) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No favorite data available"])
        }
        return try JSONDecoder().decode([Forecast].self, from: data)
    }

    static func saveFavorites(_ favorites: [Forecast]) async throws {
        let data = try JSONEncoder().encode(favorites)
        let outfile = try favoritesFileURL()
        try data.write(to: outfile)
    }
}

// Represents functions on toggling the favorite status on forecasts
extension Forecast {
    func isFavorite(_ favorites: [Forecast]) -> Bool {
        favorites.contains(where: { $0.locationInput.lowercased() == self.locationInput.lowercased() })
    }

    mutating func removeFavorite(from favorites: inout [Forecast]) {
        if let index = favorites.firstIndex(where: { $0.locationInput.lowercased() == self.locationInput.lowercased() }) {
            self.isFavorite = false
            favorites.remove(at: index)
        }
    }

    mutating func addFavorite(to favorites: inout [Forecast]) {
        self.isFavorite = true
        favorites.append(self)
    }

    mutating func setFavorite() {
        self.isFavorite = true
    }

    func updateSelfInFavorites(_ favorites: inout [Forecast]) {
        if let index = favorites.firstIndex(where: { $0.locationInput.lowercased() == self.locationInput.lowercased() }) {
            favorites[index] = self
        }
    }
}

extension Forecast {
    static let sampleData: Forecast =
        .init(
            approvedTime: "2023-11-22 14:00",
            locationInput: "Stockholm",
            coordinates: Coordinates(lat: 59, lon: 18),
            hourly: [
                Hourly(time: "13", temperature: 7.6, symbol: .fog),
                Hourly(time: "14", temperature: 15.2, symbol: .heavySnowfall),
                Hourly(time: "15", temperature: 12.1, symbol: .halfclearSky),
                Hourly(time: "16", temperature: 18.4, symbol: .lightSnowfall),
                Hourly(time: "17", temperature: 14.9, symbol: .thunder),
                Hourly(time: "18", temperature: 11.7, symbol: .lightRain),
                Hourly(time: "19", temperature: 8.4, symbol: .heavyRain),
                Hourly(time: "20", temperature: 6.3, symbol: .nearlyClearSky),
                Hourly(time: "21", temperature: 5.8, symbol: .moderateSnowfall),
                Hourly(time: "22", temperature: -1.8, symbol: .moderateSleetShowers),
            ],
            daily: [
                Daily(date: "2023-11-23", maxTemperature: 15.0, symbol: .clearSky),
                Daily(date: "2023-11-24", maxTemperature: 17.0, symbol: .lightRainShowers),
                Daily(date: "2023-11-25", maxTemperature: 10.0, symbol: .moderateRain),
                Daily(date: "2023-11-26", maxTemperature: 12.0, symbol: .cloudySky),
                Daily(date: "2023-11-27", maxTemperature: 16.0, symbol: .overcast),
                Daily(date: "2023-11-28", maxTemperature: 10.0, symbol: .moderateRain),
                Daily(date: "2023-11-29", maxTemperature: 12.0, symbol: .cloudySky),
                Daily(date: "2023-11-30", maxTemperature: 16.0, symbol: .heavySnowfall),
                Daily(date: "2023-11-31", maxTemperature: 12.0, symbol: .cloudySky),
                Daily(date: "2023-11-32", maxTemperature: 16.0, symbol: .heavyRain),
            ],
            isFavorite: false
        )

    static var sampleFavorites: [Forecast] {
        return [
            Forecast(approvedTime: "2023-11-23 15:00", locationInput: "Stockholm", coordinates: Coordinates(lat: 59, lon: 18), hourly: [
                Hourly(time: "15", temperature: 12.1, symbol: .halfclearSky),
                Hourly(time: "16", temperature: 18.4, symbol: .lightSnowfall),
            ], daily: [], isFavorite: true),
            Forecast(approvedTime: "2023-11-23 16:00", locationInput: "Kalmar", coordinates: Coordinates(lat: 60, lon: 19), hourly: [
                Hourly(time: "16", temperature: 18.4, symbol: .heavyRain),
                Hourly(time: "17", temperature: 14.9, symbol: .thunder),
            ], daily: [], isFavorite: true),
            Forecast(approvedTime: "2023-11-23 17:00", locationInput: "Öland", coordinates: Coordinates(lat: 60, lon: 19), hourly: [
                Hourly(time: "17", temperature: 14.9, symbol: .heavySnowfall),
                Hourly(time: "18", temperature: 11.7, symbol: .lightRain),
            ], daily: [], isFavorite: true),
        ]
    }
}
