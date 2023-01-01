//
//  Common.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 30/12/22.
//

import Foundation


public enum Status: String, Codable, CaseIterable {
    case Alive
    case Dead
    case unknown
}

public enum Species: String, Codable, CaseIterable {
    case Alien = "Alien"
    case Animal = "Animal"
    case Mythological = "Mythological Creature"
    case Human = "Human"
    case unknown = "unknown"
    
    public init(from decoder: Decoder) {
        let container = try? decoder.singleValueContainer()
        let rawString = try? container?.decode(String.self)
        if let text = rawString, let userType = Species(rawValue: text) {
            self = userType
        } else {
            self = .unknown
        }
    }
}

public enum Gender: String, Codable, CaseIterable {
    case Male
    case Female
    case Genderless
    case unknown
}


public struct Place: Codable {
    let name: String
    let url: String
}
