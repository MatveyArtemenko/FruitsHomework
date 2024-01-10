//
//  ContentView.swift
//  FruitsHomework
//
//  Created by Matvii Artemenko on 08/01/2024.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject var fruitsVM = FruitsViewModel()
    @StateObject var StatisticVM = StatisticsManager()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
