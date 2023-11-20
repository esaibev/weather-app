//
//  WeatherApp.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-20.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var weatherVM = WeatherVM()

    var body: some Scene {
        WindowGroup {
            WeatherView()
                .environmentObject(weatherVM)
        }
    }
}
