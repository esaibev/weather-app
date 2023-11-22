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
        VStack {
            if let errorMessage = weatherVM.errorMessage {
                Text(errorMessage)
            }
            // Rest of view content
            Text("Text")
        }
        .task {
            await weatherVM.getWeather()
        }
        .onChange(of: scenePhase) {
            if scenePhase == .inactive {
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
