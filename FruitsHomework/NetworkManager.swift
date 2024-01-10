//
//  NetworkManager.swift
//  FruitsHomework
//
//  Created by Matvii Artemenko on 08/01/2024.
//

import Combine
import Foundation

class Network {
    static let shared = Network()

    private let urlSession = URLSession(configuration: .default)

    func getData<T: Codable>(with url: URL) -> AnyPublisher<T, Error> {
        urlSession.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200, response.statusCode < 300
                else {
                    throw URLError(.badServerResponse)
                }
//                self.printJSON(data: data)
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func sendData(with url: URL) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            self?.printJSON(data: data)
            do {
                let response = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print("Success: \(response)")
            } catch {
                print(error)
            }
        }
        task.resume()

    }

    private func printJSON(data: Data) {
        if let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
           let data = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
           let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        {
            print(string)
        }
    }
}
