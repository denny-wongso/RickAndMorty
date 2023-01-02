//
//  CharacterFilterViewModel.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 1/1/23.
//

import Foundation

public protocol CharacterFilterViewModelProtocol {
    func getStatus() -> [String]
    func getSpecies() -> [String]
    func getGender() -> [String]
}


public class CharacterFilterViewModel: CharacterFilterViewModelProtocol {
    public func getSpecies() -> [String] {
        return Species.allCases.map({ $0.rawValue })
    }
    
    public func getGender() -> [String] {
        return Gender.allCases.map({ $0.rawValue })
    }
    
    public func getStatus() -> [String] {
        return Status.allCases.map({ $0.rawValue })
    }
    
    
}
