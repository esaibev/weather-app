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
        VStack {}
//            .onAppear {
//                weatherVM.fetchWeather()
//            }
            .task {
                await weatherVM.loadWeatherData()
            }
            .onChange(of: scenePhase) {
                if scenePhase == .inactive {
                    Task {
                        await weatherVM.saveWeatherData()
                    }
                }
            }
    }
}

#Preview {
    WeatherView()
        .environment(WeatherVM())
}
