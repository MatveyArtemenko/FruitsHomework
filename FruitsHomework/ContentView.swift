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
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(fruitsVM.fruits, id: \.self) { fruit in

                        NavigationLink {
                            FruitDetailView(fruit: fruit, startTime: startTime, statisticsM: statisticM)

                        } label: {

                            VStack(alignment: .leading) {
                                Text(fruit.type.capitalized)
                                    .font(.headline)
                                    .padding(10)

                            }

                        }

                    }

                }
                .listStyle(.grouped)

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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
