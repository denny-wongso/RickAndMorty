//
//  Info.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 30/12/22.
//

import Foundation


public struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
