//
//  NetworkManager.swift
//  FruitsHomework
//
//  Created by Matvii Artemenko on 08/01/2024.
//

import Combine
import Foundation

protocol NetworkProtocol {
    func getData<T: Codable>(with url: URL) -> AnyPublisher<T, Error>
    func sendData(with url: URL, completion: @escaping (Result<Data, Error>) -> ())
}

class Network: NetworkProtocol {
    static let shared: NetworkProtocol = Network()

    private let urlSession = URLSession(configuration: .default)

    // Network call for getting data from api
    func getData<T: Codable>(with url: URL) -> AnyPublisher<T, Error> {
        urlSession.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200, response.statusCode < 300

                else {
                    throw NetworkError.badServerResponse
                }
//                self.printJSON(data: data)
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    // Network call for sending a Get request
    func sendData(with url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data else {
                completion(.failure(NetworkError.noDataRecieved))
                return
            }
            
            if let error = error {
                completion(.failure(error))
            }
                self?.printJSON(data: data)
            completion(.success(data))
        }
        task.resume()

    }

    // function for formatting and printing parsed JSON data
    private func printJSON(data: Data) {
        if let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
           let data = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
           let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        {
            print("Success:")
            print(string)
        }
    }
}

enum NetworkError: LocalizedError {
    case badServerResponse
    case noDataRecieved
}
