//
//  DailyForecastView.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-22.
//

import SwiftUI

struct DailyForecastsView: View {
    @Environment(WeatherVM.self) var weatherVM

    var body: some View {
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

#Preview {
    DailyForecastsView()
        .environment(WeatherVM(sampleData: Forecast.sampleData))
}
