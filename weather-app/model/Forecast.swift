//
//  Forecast.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-22.
//

import Foundation

struct Forecast: Codable {
    var approvedTime: String
    var daily: [Daily]

    struct Daily: Codable {
        let date: String
        let maxTemperature: Double
        let symbol: WeatherSymbol
    }
}

// Represents functions on Forecast
extension Forecast {
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
            .appendingPathComponent("forecastData.data")
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
