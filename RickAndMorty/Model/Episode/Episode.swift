//
//  Episode.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 2/1/23.
//

import Foundation


public struct Episode: Codable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
