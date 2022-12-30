//
//  CharacterService.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 30/12/22.
//

import Foundation


protocol CharacterApi {
    func getCharacters(success: ((CharacterResponse?) -> Void)?, fail: ((HTTPError) -> Void)?)
    func getNextCharacters(nextURL: String, success: ((CharacterResponse?) -> Void)?, fail: ((HTTPError) -> Void)?)
}

public class CharacterService: CharacterApi {
    var url: String
    var request: URLSessionRequestProtocol
    
    init(request: URLSessionRequestProtocol, url: String) {
        self.request = request
        self.url = BaseService.BaseURL + url
    }
    
    func getCharacters(success: ((CharacterResponse?) -> Void)?, fail: ((HTTPError) -> Void)?) {
        guard let urlComponents = URLComponents(string: url), let url = urlComponents.url else {
            fail?(.urlFailed)
                return
              }
        
        request.request(url: url, handler: {[success, fail] (data, response, error) in
            guard error == nil, let data = data else {
                fail?(.noData)
                return
            }
           
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(CharacterResponse.self, from: data) {
                success?(response)
            } else {
                fail?(.parsingFailed)
            }
        })
    }
    
    func getNextCharacters(nextURL: String, success: ((CharacterResponse?) -> Void)?, fail: ((HTTPError) -> Void)?) {
        guard let urlComponents = URLComponents(string: nextURL), let url = urlComponents.url else {
            fail?(.urlFailed)
                return
              }
        
        request.request(url: url, handler: {[success, fail] (data, response, error) in
            guard error == nil, let data = data else {
                fail?(.noData)
                return
            }
           
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(CharacterResponse.self, from: data) {
                success?(response)
            } else {
                fail?(.parsingFailed)
            }
        })
    }
}

public struct CharacterResponse: Codable {
    let info: Info
    let results: [Character]?
}
