//
//  Common.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 30/12/22.
//

import Foundation
import UIKit


public enum Status: String, Codable, CaseIterable {
    case Alive
    case Dead
    case unknown
    
    func getIcon() -> UIImage? {
        switch self {
        case .Alive:
            return UIImage(named: "alive")
        case .Dead:
            return UIImage(named: "dead")
        case .unknown:
            return UIImage(named: "unknown")
        }
    }
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
    func getIcon() -> UIImage? {
        switch self {
        case .Male:
            return UIImage(named: "male")
        case .Female:
            return UIImage(named: "female")
        case .Genderless:
            return UIImage(named: "neutral")
        case .unknown:
            return UIImage(named: "unknown")
        }
    }
}


public struct Place: Codable {
    let name: String
    let url: String
}
