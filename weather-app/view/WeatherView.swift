//
//  ContentView.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-20.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject var weatherVM: WeatherVM

    var body: some View {
        VStack {
//            if let weatherData = weatherVM.weatherData {
//                Text("Weather Data Fetched")
//                Text("Approved Time: \(weatherData.approvedTime)")
//                Text("Reference Time: \(weatherData.referenceTime)")
////                Text("Symbol: \(weatherData.timeSeries.first?.parameters.first?.values.first)")
//            } else if let errorMessage = weatherVM.errorMessage {
//                Text("Error: \(errorMessage)")
//            } else {
//                Text("Fetching Weather Data...")
//            }
        }
        .onAppear {
            weatherVM.fetchWeather()
        }
    }
}

#Preview {
    WeatherView()
        .environmentObject(WeatherVM())
}
