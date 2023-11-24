//
//  Forecast.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-22.
//

import Foundation

struct Forecast: Codable {
    private(set) var approvedTime: String
    private(set) var daily: [Daily]

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

extension Forecast {
    static let sampleData: Forecast =
        .init(
            approvedTime: "2023-11-22 14:00",
            daily: [
                Daily(date: "2023-11-23", maxTemperature: 15.0, symbol: .clearSky),
                Daily(date: "2023-11-24", maxTemperature: 17.0, symbol: .lightRainShowers),
                Daily(date: "2023-11-25", maxTemperature: 10.0, symbol: .moderateRain),
                Daily(date: "2023-11-26", maxTemperature: 12.0, symbol: .cloudySky),
                Daily(date: "2023-11-27", maxTemperature: 16.0, symbol: .overcast),
            ]
        )
}
