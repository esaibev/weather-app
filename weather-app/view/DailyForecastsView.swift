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
        VStack {
            ForEach(weatherVM.forecast.daily.indices, id: \.self) { index in
                let daily = weatherVM.forecast.daily[index]
                HStack {
                    Text(daily.date)
                    Spacer()
                    Image(systemName: daily.symbol.iconName)
                        .imageScale(.large)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.teal, .yellow)
                    Text("\(daily.maxTemperature, specifier: "%.1f") °C")
                }
                .padding(8)
                if index < weatherVM.forecast.daily.indices.last! {
                    Divider()
                }
            }
        }
        .padding(10)
        .background(Color(red: 0.468, green: 0.588, blue: 0.879), in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    DailyForecastsView()
        .environment(WeatherVM(sampleData: Forecast.sampleData))
}
