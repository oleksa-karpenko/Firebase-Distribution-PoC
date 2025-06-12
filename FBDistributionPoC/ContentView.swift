//
//  ContentView.swift
//  FBDistributionPoC
//
//  Created by Oleksandr Karpenko on 12.06.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.largeTitle)
            Text("Playing with the Firebase Distribution!")
                .font(.subheadline)
            Spacer()
            Text("Version: 0.0.1")
            

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
