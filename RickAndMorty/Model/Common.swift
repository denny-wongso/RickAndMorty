//
//  Common.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 30/12/22.
//

import Foundation


public enum Status: String, Codable {
    case Alive
    case Dead
    case unknown
}

public enum Species: String, Codable {
    case Alien = "Alien"
    case Animal = "Animal"
    case Mythological = "Mythological Creature"
    case Human = "Human"
}

public enum Gender: String, Codable {
    case Male
    case Female
    case Genderless
    case unknown
}


public struct Place: Codable {
    let name: String
    let url: String
}
