//
//  ContentView.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-27.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @Environment(WeatherVM.self) var weatherVM

    var body: some View {
        TabView {
            WeatherView()
                .toolbarBackground(.yellow, for: .navigationBar)
                .tabItem {
                    Image(systemName: "sun.max")
                        .environment(\.symbolVariants, .none)
                    Text("Weather")
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: "star")
                        .environment(\.symbolVariants, .none)
                    Text("Favorites")
                }
        }
        .onAppear {
            UITabBar.appearance().barTintColor = UIColor(Color(red: 0.378, green: 0.49, blue: 0.757))
            UITabBar.appearance().unselectedItemTintColor = UIColor(Color(.lightGray))
        }
        .tint(.white)
    }
}

#Preview {
    ContentView()
        .environment(WeatherVM(sampleData: Forecast.sampleData, sampleFavorites: Forecast.sampleFavorites))
}
