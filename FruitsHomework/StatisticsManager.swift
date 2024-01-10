//
//  StatisticsManager.swift
//  FruitsHomework
//
//  Created by Matvii Artemenko on 10/01/2024.
//

import Foundation

class StatisticsManager: ObservableObject {
    @Published var startTime: Date?

    init() {
        getStats(for: .load, "1234")
    }

    func getStats(for event: ScreeningEvents, _ data: String) {
        let urlString = "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/stats?event=\(event.rawValue)&data=\(data)"
        guard let url = URL(string: urlString) else {
            return
        }

        Network.shared.sendData(with: url)
    }
}

enum ScreeningEvents: String {
    case load
    case display
    case error
}
