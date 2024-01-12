//
//  StatisticsManager.swift
//  FruitsHomework
//
//  Created by Matvii Artemenko on 10/01/2024.
//

import Foundation
import OSLog

class StatisticsManager: ObservableObject {
    let logger = Logger(subsystem: "matvii.FruitsHomework", category: "StatisticsManager")
    @Published var startTime: DispatchTime?

    // Load event – any network request, data is time in ms
    @discardableResult
    func networkCallStats(block: () -> ()) -> Double {
        let clock = ContinuousClock()
        let result = clock.measure {
            block()
        }
        let duration = result.description.trimmingCharacters(in: .letters)
        print("result = \(duration)")
        getStats(for: .load, "\(duration.trimmingCharacters(in: .whitespacesAndNewlines))")
        return Double(result.components.seconds)
    }

    // Display event – when ever a screen is shown, data is time in ms
    @discardableResult
    func displayEventStats() -> Result<Double, Error> {

        guard let startTime = startTime else {
            return .failure(StatisticsError.invalidStartTime)
        }
        print("\(startTime.uptimeNanoseconds)")
        let endTime = DispatchTime.now()

        let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let elapsedTimeInMilliSeconds = Double(elapsedTime) / 1_000_000.0
        print("Display event: \(elapsedTimeInMilliSeconds) ms")
        getStats(for: .display, String(elapsedTimeInMilliSeconds))

        return .success(elapsedTimeInMilliSeconds)
    }
    
    // Error event – sent when ever there is a raised exception or application crash
    func errorEventStats(block: () throws -> ()) {
        do {
            try block()
        } catch {
            logger.error("error occured: \(StatisticsError.coughtErrorOrExaption))")
            getStats(for: .error, error.localizedDescription.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
    }

    // Sending data from events in a url to server
    @discardableResult
    func getStats(for event: ScreeningEvents, _ data: String) -> Result<String, Error> {
        let urlString = "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/stats?event=\(event.rawValue)&data=\(data)"
//        print("Url: \(urlString)")
        guard let url = URL(string: urlString) else {
            return .failure(StatisticsError.invalidURL)
        }

        Network.shared.sendData(with: url){_ in }
        return .success(urlString)
    }
}

enum ScreeningEvents: String {
    case load
    case display
    case error
}

enum StatisticsError: LocalizedError {
    case invalidURL
    case coughtErrorOrExaption
    case invalidStartTime
}
