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
                    .imageScale(.large)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.teal, .yellow)
                Text("\(daily.maxTemperature, specifier: "%.1f") °C")
            }
            .padding([.top, .bottom], 8)
            Divider()
        }
    }
}

#Preview {
    DailyForecastsView()
        .environment(WeatherVM(sampleData: Forecast.sampleData))
}
