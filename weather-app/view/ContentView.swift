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
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            WeatherView()
                .toolbarBackground(.yellow, for: .navigationBar)
                .tabItem {
                    Image(systemName: "sun.max")
                        .environment(\.symbolVariants, .none)
                    Text("Weather")
                }
                .tag(0)
            FavoritesView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "star")
                        .environment(\.symbolVariants, .none)
                    Text("Favorites")
                }
                .tag(1)
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
