//
//  FruitDetailView.swift
//  FruitsHomework
//
//  Created by Matvii Artemenko on 10/01/2024.
//

import SwiftUI

struct FruitDetailView: View {
    @Environment(\.dismiss) var dismiss
    let fruit: Fruit
    let startTime: DispatchTime
    @ObservedObject var statisticsM: StatisticsManager
    var body: some View {

        VStack {
            Text(fruit.type.capitalized)
                .font(.largeTitle)
                .padding(.vertical)
            HStack(alignment: .firstTextBaseline) {

                VStack(alignment: .leading) {
                    Text("Price")
                    Text(fruit.price, format: .currency(code: "GBR"))
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Weight")
                    Text("\(fruit.weight) kg")
                }
            }
            .font(.headline)
            .padding()
            .background(.regularMaterial)
            Spacer()
        }
        .onAppear {
            // end point for statistics event (display)
            // also chacking for errors and length of network call events
            statisticsM.errorEventStats {
                statisticsM.networkCallStats {
                    statisticsM.displayEventStats()

                }
            }

        }
        .navigationBarTitleDisplayMode(.inline)
    }

}

struct FruitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FruitDetailView(fruit: Fruit(type: "Kiwi", price: 89, weight: 200), startTime: .now(), statisticsM: StatisticsManager())
    }
}
