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
        ScrollView {
            VStack(alignment: .leading) {
                Text("Weather").font(.title).fontWeight(.heavy)
                Text("Approved time: \(weatherVM.forecast.approvedTime)")
                    .padding(.bottom)
                VStack(alignment: .leading) {
                    DailyForecastsView()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(red: 0.378, green: 0.49, blue: 0.757))
        .preferredColorScheme(/*@START_MENU_TOKEN@*/ .dark/*@END_MENU_TOKEN@*/)
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
