//
//  URLSessionRequest.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 30/12/22.
//

import Foundation

protocol URLSessionRequestProtocol {
    func request(url: URL, handler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

public class URLSessionRequest: URLSessionRequestProtocol {
    func request(url: URL, handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: handler).resume()
    }
}
