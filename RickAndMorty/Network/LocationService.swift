//
//  LocationService.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 2/1/23.
//

import Foundation

protocol LocationApi {
    func getLocation(success: ((LocationResponse?) -> Void)?, fail: ((HTTPError) -> Void)?)
    func getNextLocation(nextURL: String, success: ((LocationResponse?) -> Void)?, fail: ((HTTPError) -> Void)?)
}

public class LocationService: LocationApi {
    var url: String
    var request: URLSessionRequestProtocol
    
    init(request: URLSessionRequestProtocol, url: String) {
        self.request = request
        self.url = BaseService.BaseURL + url
    }
    
    func getLocation(success: ((LocationResponse?) -> Void)?, fail: ((HTTPError) -> Void)?) {
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
            if let response = try? decoder.decode(LocationResponse.self, from: data) {
                success?(response)
            } else {
                fail?(.parsingFailed)
            }
        })
    }
    
    func getNextLocation(nextURL: String, success: ((LocationResponse?) -> Void)?, fail: ((HTTPError) -> Void)?) {
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
            if let response = try? decoder.decode(LocationResponse.self, from: data) {
                success?(response)
            } else {
                fail?(.parsingFailed)
            }
        })
    }
}

public struct LocationResponse: Codable {
    let info: Info
    let results: [Location]?
}
