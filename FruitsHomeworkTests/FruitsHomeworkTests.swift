//
//  FruitsHomeworkTests.swift
//  FruitsHomeworkTests
//
//  Created by Matvii Artemenko on 11/01/2024.
//

import Combine
import XCTest
@testable import FruitsHomework

final class FruitsHomeworkTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_FruitsViewModel_getFruits_ShouldBeCorrectAmoutOfItemsFromAPI() {
        // Given
        let fruitVM = FruitsViewModel()
        // When
        fruitVM.getFruits()
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(fruitVM.fruits.count, 9)

        }
    }

    func test_StatisticsManager_networkCallStats_TimesShouldBeLessThen() {
        // Given
        let manager = StatisticsManager()
        let fruitVM = FruitsViewModel()
        var expectation = XCTestExpectation(description: "Async operation expectation")

        // When
        let time = manager.networkCallStats {
            fruitVM.getFruits()
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertLessThan(time, 1)
    }

    func test_StatisticsManager_displayEventStats_TimesShouldNotBeZero() {
        // Given
        let manager = StatisticsManager()
        manager.startTime = .now()
        let expectation = XCTestExpectation(description: "Async operation expectation")
        var duration = 0.0
        // When
        let result = manager.displayEventStats()
        switch result {
        case .success(let success):
            duration = success
        case .failure(let failure):
            XCTFail(failure.localizedDescription)
        }
        expectation.fulfill()

        // Then
        wait(for: [expectation], timeout: 2)
        XCTAssertNotEqual(duration, 0.0)
    }

    func test_StatisticsManager_getStats_urlShouldBeTheSame() {
        // Given
        let manager = StatisticsManager()
        let randomData = Int.random(in: 1 ..< 9999)
        let event = ScreeningEvents.display
        let testUrlString = "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/stats?event=\(event.rawValue)&data=\(randomData)"
        var statUrl = ""

        // When
        let result = manager.getStats(for: event, "\(randomData)")

        switch result {
        case .success(let success):
            statUrl = success
        case .failure(let failure):
            XCTFail(failure.localizedDescription)
        }
        // Then
        XCTAssertEqual(statUrl, testUrlString)
    }

    func test_NetworkManager_getData_requestShouldNotFail() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch data from the server")
        let testURL = URL(string: "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/data.json")!

        // When

        Network.shared.getData(with: testURL)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Failed to fetch data with error: \(error)")
                case .finished:
                    print("Completion: \(completion)")

                }
                expectation.fulfill()
            } receiveValue: { (_: FruitsResponse) in }
            .store(in: &cancellables)

        // Then

        wait(for: [expectation], timeout: 5.0)

    }
    
    func test_NetworkManager_sendData_requestShouldNotFail() {
        // Given
        let expectation = XCTestExpectation(description: "Send data to the server")
        let testURL = URL(string: "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/data.json")!

        // When

        Network.shared.sendData(with: testURL, completion: { result in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
                
            case .success(_):
                expectation.fulfill()
            }
        })

        // Then

        wait(for: [expectation], timeout: 5.0)

    }
}
