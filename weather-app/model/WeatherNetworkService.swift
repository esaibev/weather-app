//
//  WeatherNetworkService.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-20.
//

import Foundation
import Network

struct WeatherNetworkService {
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
    
    static func fetchWeatherData(completion: @escaping (Result<WeatherData, Error>) -> Void) {
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
    
    private static func parseWeatherData(data: Data, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        do {
            let decoder = JSONDecoder()
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            
            DispatchQueue.main.async {
                completion(.success(weatherData))
            }
        } catch {
            // Handle parsing error
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
