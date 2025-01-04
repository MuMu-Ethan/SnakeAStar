//
//  MapView.swift
//  SnakeAStar
//
//  Created by MuMu on 1/2/25.
//

import SwiftUI

struct MapView: View {
    @Environment(SnakeAStarViewModel.self) var viewModel
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<viewModel.mapWidth) { column in
                VStack(spacing: 0) {
                    ForEach(0..<viewModel.mapHeight) { row in
                        let color: Color = {
                            let object = viewModel.fullMap[column][row]
                            switch object {
                            case 1:
                                return .green
                            case 2:
                                return .red
                            default:
                                return .black
                            }
                        }()
                        Rectangle()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(color)
                        
                    }
                }
            }
        }
    }
}

#Preview {
    MapView()
        .environment(SnakeAStarViewModel())
}
