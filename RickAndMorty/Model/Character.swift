//
//  Character.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 30/12/22.
//

import Foundation

public struct Character: Codable {
    let id: Int
    let name: String
    let status: Status
    let species: Species
    let type: String
    let gender: Gender
    let origin: Place
    let location: Place
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
