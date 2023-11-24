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
    @State private var locationInput: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Weather").font(.largeTitle).fontWeight(/*@START_MENU_TOKEN@*/ .bold/*@END_MENU_TOKEN@*/)
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

//                                            TextField("Enter Location", text: $locationInput)
//                                                .foregroundColor(.black)
//                                                .padding(10)
                    }
                    .frame(height: 40)

                    Button("Submit") {
                        Task {
                            await weatherVM.getWeatherForLocation(locationInput)
                        }
                    }
                    .buttonStyle(CustomButton())
                }
                .padding(.bottom)
                Text("Approved time: \(weatherVM.forecast.approvedTime)")
                    .padding(.bottom, 8)

                VStack(alignment: .leading) {
                    DailyForecastsView()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(red: 0.378, green: 0.49, blue: 0.757))
        .preferredColorScheme(/*@START_MENU_TOKEN@*/ .dark/*@END_MENU_TOKEN@*/)
//        .task {
//            await weatherVM.getWeather()
//        }
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

struct CustomButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding([.horizontal, .vertical], 12)
            .background(.cyan)
            .cornerRadius(8)
    }
}

#Preview {
    WeatherView()
        .environment(WeatherVM())
}
