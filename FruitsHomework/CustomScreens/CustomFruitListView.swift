//
//  CustomFruitListView.swift
//  FruitsHomework
//
//  Created by Matvii Artemenko on 13/01/2024.
//

import SwiftUI

struct CustomFruitListView: View {
    @ObservedObject var fruitsVM: FruitsViewModel
    @ObservedObject var statisticM: StatisticsManager
    @State private var showDetails = false
    @Binding var startTime: DispatchTime
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: UIScreen.main.bounds.width * 0.4))
    ]

    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    ForEach(fruitsVM.fruits, id: \.self) { fruit in
                        Button {
                            withAnimation {
                                showDetails.toggle()
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.regularMaterial)
                                .aspectRatio(contentMode: .fill)
                                .overlay {
                                    Text(fruit.type.capitalized)
                                        .font(.title)
                                        .foregroundColor(.black)

                                }

                        }
                        .sheet(isPresented: $showDetails) {
                            FruitDetailView(fruit: fruit, startTime: startTime, statisticsM: statisticM)
                                .presentationDetents([.fraction(0.25)])
                                .presentationCornerRadius(10)
                                .presentationDragIndicator(.visible)

                        }

                    }
                }

            }
        }

    }
}

struct CustomFruitListView_Previews: PreviewProvider {
    static var previews: some View {
        CustomFruitListView(fruitsVM: FruitsViewModel(), statisticM: StatisticsManager(), startTime: .constant(.distantFuture))
    }
}
