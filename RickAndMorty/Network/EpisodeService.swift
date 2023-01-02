//
//  EpisodeService.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 3/1/23.
//

import Foundation


protocol EpisodeApi {
    func getEpisode(success: ((EpisodeResponse?) -> Void)?, fail: ((HTTPError) -> Void)?)
    func getNextEpisode(nextURL: String, success: ((EpisodeResponse?) -> Void)?, fail: ((HTTPError) -> Void)?)
    func getImage(with path: String, success: ((Data?) -> Void)?, fail: ((HTTPError) -> Void)?)
}

public class EpisodeService: EpisodeApi {
    var url: String
    var request: URLSessionRequestProtocol
    
    init(request: URLSessionRequestProtocol, url: String) {
        self.request = request
        self.url = BaseService.BaseURL + url
    }
    
    func getEpisode(success: ((EpisodeResponse?) -> Void)?, fail: ((HTTPError) -> Void)?) {
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
            if let response = try? decoder.decode(EpisodeResponse.self, from: data) {
                success?(response)
            } else {
                fail?(.parsingFailed)
            }
        })
    }
    
    func getNextEpisode(nextURL: String, success: ((EpisodeResponse?) -> Void)?, fail: ((HTTPError) -> Void)?) {
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
            if let response = try? decoder.decode(EpisodeResponse.self, from: data) {
                success?(response)
            } else {
                fail?(.parsingFailed)
            }
        })
    }
    
    func getImage(with path: String, success: ((Data?) -> Void)?, fail: ((HTTPError) -> Void)?) {
        guard let url = URL(string: path) else {
            fail?(.urlFailed)
            return
        }
        request.request(url: url, handler: {[success, fail] (data, response, error) in
            guard error == nil, let data = data else {
                fail?(.noData)
                return
            }
            success?(data)
        })
    }
}

public struct EpisodeResponse: Codable {
    let info: Info
    let results: [Episode]?
}
