//
//  NoConnectionNotificationView.swift
//  weather-app
//
//  Created by Esaias Bevegård on 2023-11-25.
//

import SwiftUI

struct NoConnectionView: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "wifi.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.red)
            Text("No network connection. Using stored data.")
                .font(.callout)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(Color.black.opacity(0.3))
    }
}

#Preview {
    NoConnectionView()
}
