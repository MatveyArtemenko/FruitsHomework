//
//  FruitsViewModel.swift
//  FruitsHomework
//
//  Created by Matvii Artemenko on 09/01/2024.
//

import Combine
import Foundation

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
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Failure: \(error)")
                case .finished:
                    print("Completion: \(completion)")

                }
            } receiveValue: { [weak self] (fruitsResponse: FruitsResponse) in
                self?.fruits = fruitsResponse.fruit
            }
            .store(in: &cancellables)

    }

}
