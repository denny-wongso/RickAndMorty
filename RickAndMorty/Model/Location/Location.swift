//
//  Location.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 2/1/23.
//

import Foundation

public struct Location: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
