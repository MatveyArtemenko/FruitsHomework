//
//  TaskFruitListView.swift
//  FruitsHomework
//
//  Created by Matvii Artemenko on 13/01/2024.
//

import SwiftUI

struct TaskFruitListView: View {
    @ObservedObject var fruitsVM: FruitsViewModel
    @ObservedObject var statisticM: StatisticsManager
    @Binding var startTime: DispatchTime
    var body: some View {
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
}

struct TaskFruitListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskFruitListView(fruitsVM: FruitsViewModel(), statisticM: StatisticsManager(), startTime: .constant(.now()))
    }
}
