//
//  ContentView.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-20.
//

import SwiftUI

struct WeatherView: View {
    @Environment(WeatherVM.self) var weatherVM
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            List {
                Text("Approved time: \(weatherVM.forecast.approvedTime)")
                VStack(alignment: .leading) {
                    DailyForecastsView()
                }
            }
            .navigationTitle("Weather")
        }
        .task {
            await weatherVM.getWeather()
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                Task {
                    await weatherVM.saveForecast()
                }
            }
        }
    }
}

#Preview {
    WeatherView()
        .environment(WeatherVM())
}
