//
//  WeatherView.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-20.
//

import SwiftUI

struct WeatherView: View {
    @Environment(WeatherVM.self) var weatherVM
    @Environment(\.scenePhase) private var scenePhase
    @State private var locationInput: String = ""

    var body: some View {
        VStack(spacing: 0) {
            if !weatherVM.isConnected {
                NoConnectionView()
            }

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Weather").font(.largeTitle).fontWeight(.bold)
                    HStack(spacing: 16) {
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(5)

                            SuperTextField(
                                placeholder: Text("Enter Location").foregroundColor(.gray),
                                text: $locationInput
                            )
                            .padding(10)
                            .frame(height: 40)
                        }
                        .frame(height: 40)

                        Button(action: { Task { await weatherVM.getWeatherForLocation(locationInput) } }) { SubmitButton() }
                    }
                    .padding(.bottom)

                    if weatherVM.hasData {
                        HStack {
                            Text("Location: \(weatherVM.forecast.locationInput)")
                            Button(action: {
                                weatherVM.toggleFavorite()
                            }) {
                                Image(systemName: weatherVM.forecast.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .opacity(weatherVM.forecast.isFavorite ? 1 : 0.5)
                            }
                        }
                        Text("Approved time: \(weatherVM.forecast.approvedTime)")
                            .padding(.bottom, 8)

                        HourlyForecastView()
                        DailyForecastView()

                    } else {
                        Text("No weather data exists")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.378, green: 0.49, blue: 0.757))
        .preferredColorScheme(/*@START_MENU_TOKEN@*/ .dark/*@END_MENU_TOKEN@*/)
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                Task {
                    await weatherVM.saveForecast()
                }
            }
        }
    }
}

struct SuperTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = { _ in }
    var commit: () -> () = {}

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .foregroundStyle(Color(hue: 1.0, saturation: 0.0, brightness: 0.154))
        }
    }
}

struct SubmitButton: View {
    var body: some View {
        Text("Submit")
            .foregroundColor(.white)
            .padding([.horizontal, .vertical], 12)
            .background(.cyan)
            .cornerRadius(8)
    }
}

#Preview {
    WeatherView()
        .environment(WeatherVM(sampleData: Forecast.sampleData))
}
