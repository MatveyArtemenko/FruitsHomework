//
//  FruitsResponse.swift
//  FruitsHomework
//
//  Created by Matvii Artemenko on 08/01/2024.
//

import Foundation

struct FruitsResponse: Codable {
    let fruit: [Fruit]
}

struct Fruit: Codable {
    let type: String
    let price: Int
    let weight: Int
}
