//
//  FavoritesView.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-27.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(WeatherVM.self) var weatherVM
    @Binding var selectedTab: Int

    var body: some View {
        VStack(spacing: 0) {
            if !weatherVM.isConnected {
                NoConnectionView()
            }

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Favorites").font(.largeTitle).fontWeight(.bold).padding(.bottom)

                    if !weatherVM.favoriteForecasts.isEmpty {
                        FavoriteForecastView(selectedTab: $selectedTab)

                    } else {
                        Text("No favorite places exist. Add one by pressing ⭐️ next to the location in the ")
                            + Text("Weather").fontWeight(.heavy)
                            + Text(" tab.")
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.378, green: 0.49, blue: 0.757))
        .preferredColorScheme(/*@START_MENU_TOKEN@*/ .dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FavoritesView(selectedTab: .constant(1))
        .environment(WeatherVM(sampleData: Forecast.sampleData, sampleFavorites: Forecast.sampleFavorites))
}
