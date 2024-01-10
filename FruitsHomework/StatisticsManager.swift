//
//  StatisticsManager.swift
//  FruitsHomework
//
//  Created by Matvii Artemenko on 10/01/2024.
//

import Foundation

class StatisticsManager: ObservableObject {
    @Published var startTime: DispatchTime?

    func networkCallStats(block: () -> ()) {
        let clock = ContinuousClock()
        let result = clock.measure {
            block()
        }
        let duration = result.description.trimmingCharacters(in: .letters)
//        print("result = \(duration)")
        getStats(for: .load, "\(duration.trimmingCharacters(in: .whitespacesAndNewlines))")
    }

    func displayEventStats() {

        guard let startTime = startTime else {
            return
        }
        print("\(startTime.uptimeNanoseconds)")
        let endTime = DispatchTime.now()

        let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let elapsedTimeInMilliSeconds = Double(elapsedTime) / 1_000_000.0
        print("Display event: \(elapsedTimeInMilliSeconds) ms")

        getStats(for: .display, String(elapsedTimeInMilliSeconds))

    }

    func getStats(for event: ScreeningEvents, _ data: String) {
        let urlString = "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/stats?event=\(event.rawValue)&data=\(data)"
//        print("Url: \(urlString)")
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
