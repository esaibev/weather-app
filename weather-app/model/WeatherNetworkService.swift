//
//  WeatherNetworkService.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-20.
//

import Foundation

struct WeatherNetworkService {
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
            
            // For testing: print weather parameter data
            if let firstTimePeriod = weatherData.timeSeries.first {
                for parameter in firstTimePeriod.parameters {
                    print(parameter.name, parameter.values)
                }
            }
            
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
