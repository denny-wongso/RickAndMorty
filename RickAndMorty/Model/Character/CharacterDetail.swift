//
//  CharacterDetail.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 2/1/23.
//

import Foundation


public struct CharacterDetail {
    let id: Int
    let image: Data?
    let name: String
    let status: Status
    let gender: Gender
    let species: Species
    let created: String
    let origin: Place
    let location: Place
    let episode: [String]
}
