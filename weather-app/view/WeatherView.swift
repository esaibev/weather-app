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
                Text("Weather")
                    .font(.largeTitle).fontWeight(.heavy)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Approved time: \(weatherVM.forecast.approvedTime)")
                    .padding(.horizontal)

                ForEach(weatherVM.forecast.daily, id: \.date) { daily in
                    HStack {
                        Text(daily.date)
                        Spacer()
                        Image(systemName: daily.symbol.iconName)
                        Text("\(daily.maxTemperature, specifier: "%.1f") °C")
                    }
                    .padding()
                }
            }
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
