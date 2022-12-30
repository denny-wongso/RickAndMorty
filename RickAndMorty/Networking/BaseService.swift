//
//  BaseService.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 30/12/22.
//

import Foundation


public struct BaseService {
    public static let BaseURL = "https://rickandmortyapi.com/api"
}

public enum HTTPError: Error {
    case urlFailed
    case noData
    case requestError
    case parsingFailed

}
