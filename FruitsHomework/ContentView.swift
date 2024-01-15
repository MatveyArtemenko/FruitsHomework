//
//  ContentView.swift
//  FruitsHomework
//
//  Created by Matvii Artemenko on 08/01/2024.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject var fruitsVM = FruitsViewModel()
    @StateObject var statisticM = StatisticsManager()
    @State private var startTime: DispatchTime = .now()
    @State private var showCustomScreen = false
    var body: some View {
        NavigationStack {
            VStack {
                if showCustomScreen {
                    CustomFruitListView(fruitsVM: fruitsVM, statisticM: statisticM, startTime: $startTime)
                } else {
                    TaskFruitListView(fruitsVM: fruitsVM, statisticM: statisticM, startTime: $startTime)
                }

            }
            .refreshable {
                // calling fonctions to allow refresh list of fruits as part of the task
                
                statisticM.errorEventStats {
                    statisticM.networkCallStats {
                        fruitsVM.getFruits()
                    }
                }
                
            }
            .onDisappear {
                // start point for statistics task (display)
                statisticM.startTime = .now()

            }
            .navigationTitle("FruitList")
            .toolbar {
                Button {
                    withAnimation(.spring()) {
                        showCustomScreen.toggle()
                    }
                } label: {
                    Image(systemName: showCustomScreen ? "rectangle.grid.1x2.fill" : "rectangle.grid.2x2.fill")
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
