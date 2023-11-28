//
//  HourlyForecastView.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-26.
//

import SwiftUI

struct HourlyForecastView: View {
    @Environment(WeatherVM.self) var weatherVM

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "clock")
                    .imageScale(.small)
                    .scaledToFit()
                Text("HOURLY FORECAST")
                    .font(.footnote)
                    .fontWeight(.medium)
            }
            .opacity(0.8)
            .padding(.bottom, 8)

            Divider()

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 20) {
                    ForEach(weatherVM.forecast.hourly) { hourly in
                        VStack(alignment: .center, spacing: 16) {
                            Text(hourly.time)
                            Image(systemName: hourly.symbol.iconName)
                                .imageScale(.large)
                                .scaledToFit()
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.teal, .yellow)
                                .frame(width: 32, height: 32)
                            Text("\(hourly.temperature, specifier: "%.1f")°")
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .padding([.top, .horizontal], 18)
        .padding(.bottom, 10)
        .background(Color(red: 0.468, green: 0.588, blue: 0.879), in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HourlyForecastView()
        .environment(WeatherVM(sampleData: Forecast.sampleData, sampleFavorites: Forecast.sampleFavorites))
}
