//
//  WeatherNetworkService.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-20.
//

import Foundation
import Network

private struct GeocodeResult: Codable {
    var lat: String
    var lon: String
}

enum WeatherNetworkService {
    static func isConnectedToInternet(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            let isConnected = path.status == .satisfied
            completion(isConnected)
            monitor.cancel()
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    static func getCoordinates(for location: String) async throws -> Coordinates {
        guard let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://geocode.maps.co/search?q=\(encodedLocation)")
        else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let results = try decoder.decode([GeocodeResult].self, from: data)

        guard let firstResult = results.first,
              var lat = Double(firstResult.lat),
              var lon = Double(firstResult.lon)
        else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])
        }
        
        // Efficiently round to 6 decimal places
        lat = round(lat * 1_000_000) / 1_000_000
        lon = round(lon * 1_000_000) / 1_000_000

        let nr = lat.formatted(.number.precision(.fractionLength(6)))
        return Coordinates(lat: lat, lon: lon)
    }
    
    static func getForecast(for coordinates: Coordinates) async throws -> Forecast {
        let urlString = "https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point/lon/\(coordinates.lon)/lat/\(coordinates.lat)/data.json"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let weatherData = try decoder.decode(WeatherData.self, from: data)
        return weatherData.process()
    }
    
    static func fetchForecastData(completion: @escaping (Result<Forecast, Error>) -> Void) {
        let urlString = "https://maceo.sth.kth.se/weather/forecast?lonLat=lon/14.333/lat/60.383"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                // Handle error scenario
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                // Handle no data scenario
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            // Move to parsing the data
            DispatchQueue.global(qos: .userInitiated).async {
                parseWeatherData(data: data, completion: completion)
            }
        }
        
        task.resume()
    }
    
    private static func parseWeatherData(data: Data, completion: @escaping (Result<Forecast, Error>) -> Void) {
        do {
            let decoder = JSONDecoder()
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            let forecast = weatherData.process()
            
            DispatchQueue.main.async {
                completion(.success(forecast))
            }
        } catch {
            // Handle parsing error
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
