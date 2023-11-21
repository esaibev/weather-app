//
//  ContentView.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-20.
//

import SwiftUI

struct WeatherView: View {
    @Environment(WeatherVM.self) var weatherVM

    var body: some View {
        VStack {}
            .onAppear {
                weatherVM.fetchWeather()
            }
    }
}

#Preview {
    WeatherView()
        .environment(WeatherVM())
}
