//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 30/12/22.
//

import Foundation

public struct CharacterModel {
    let id: Int
    let image: String
    let name: String
    let species: String
    var imageData: Data?
    
    mutating func addImageData(imageData: Data?) {
        self.imageData = imageData
    }
}
