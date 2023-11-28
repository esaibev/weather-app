//
//  FavoriteForecastView.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-28.
//

import SwiftUI

struct FavoriteForecastView: View {
    @Environment(WeatherVM.self) var weatherVM

    var body: some View {
        ForEach(weatherVM.favoriteForecasts, id: \.id) { favorite in
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(favorite.locationInput)").font(.title2).fontWeight(.bold)
//                    Spacer()
                    Text("\(favorite.hourly[0].symbol.description)")
                        .opacity(0.8)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(favorite.hourly[0].temperature, specifier: "%0.1f")°")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
//                    Spacer()
                    Image(systemName: favorite.hourly[0].symbol.iconName)
//                        .imageScale(.large)
                        .scaledToFit()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.teal, .yellow)
                        .frame(height: 20)
                }
                .padding(.top, 4)
            }
            .padding(18)
            .background(Color(red: 0.468, green: 0.588, blue: 0.879), in: RoundedRectangle(cornerRadius: 16))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    FavoriteForecastView()
        .environment(WeatherVM(sampleData: Forecast.sampleData, sampleFavorites: Forecast.sampleFavorites))
}
