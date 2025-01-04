//
//  ContentView.swift
//  SnakeAStar
//
//  Created by MuMu on 1/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = SnakeAStarViewModel()

    var body: some View {
        MapView()
            .environment(viewModel)
            .onAppear {
                let _ = Timer.scheduledTimer(
                    withTimeInterval: 0.002,
                    repeats: true
                ) { _ in
                    viewModel.update()
                }
            }
    }
}

#Preview {
    ContentView()
}
