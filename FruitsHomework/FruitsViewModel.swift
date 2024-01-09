//
//  FruitsViewModel.swift
//  FruitsHomework
//
//  Created by Matvii Artemenko on 09/01/2024.
//

import Foundation
import Combine

class FruitsViewModel: ObservableObject {
    @Published var fruits: [Fruit] = []
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getFruits()
    }
    
    func getFruits() {
        guard let url = URL(string: "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/data.json") else {
            return
        }
        
        Network.shared.getData(with: url)
            .sink { (completion) in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] (fruitsResponse: FruitsResponse) in
                print(fruitsResponse.fruit.count)
                self?.fruits = fruitsResponse.fruit
            }
            .store(in: &cancellables)

    }
    
}
