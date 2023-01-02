//
//  CharacterServiceTests.swift
//  RickAndMortyTests
//
//  Created by Denny Wongso on 30/12/22.
//

import XCTest
@testable import RickAndMorty


class CharacterServiceTests: XCTestCase {
    func testURLIsCorrect() {
        let service = CharacterService(request: MockURLSessionRequest(), url: "/character")
        XCTAssertEqual(service.url, BaseService.BaseURL + "/character")
    }
    
    func testSuccessfullyGetCharacters() {
        let expectation = expectation(description: "get characters")
        
        let info = Info(count: 42, pages: 10, next: "somewhere", prev: nil)
        let character1 = Character(id: 1, name: "a", status: .Alive, species: .Alien, type: "-", gender: .Genderless, origin: Place(name: "b", url: "somewhereb"), location: Place(name: "b", url: "somewhereb"), image: "s", episode: ["1","2"], url: "", created: "")
        let character2 = Character(id: 1, name: "a", status: .Alive, species: .Alien, type: "-", gender: .Genderless, origin: Place(name: "b", url: "somewhereb"), location: Place(name: "b", url: "somewhereb"), image: "s", episode: ["1","2"], url: "", created: "")
        let arr = [character1, character2]
        let response = CharacterResponse(info: info, results: arr)
        
        let session = MockURLSessionRequest(data: response)
        let service = CharacterService(request: session, url: "/character")
        service.getCharacters(success: {(response) in
            XCTAssertEqual(response?.results?.count, arr.count)
            expectation.fulfill()
        }, fail: {(error) in
            XCTFail("Error: \(error)")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testSuccessfullyUsesNextUrlForNextSetOfCharacters() {
        let expectation = expectation(description: "get next characters")
        
        let info = Info(count: 42, pages: 10, next: "https://rickandmortyapi.com/api/character/2", prev: nil)
        let character1 = Character(id: 1, name: "a", status: .Alive, species: .Alien, type: "-", gender: .Genderless, origin: Place(name: "b", url: "somewhereb"), location: Place(name: "b", url: "somewhereb"), image: "s", episode: ["1","2"], url: "", created: "")
        let character2 = Character(id: 1, name: "a", status: .Alive, species: .Alien, type: "-", gender: .Genderless, origin: Place(name: "b", url: "somewhereb"), location: Place(name: "b", url: "somewhereb"), image: "s", episode: ["1","2"], url: "", created: "")
        let arr = [character1, character2]
        let response = CharacterResponse(info: info, results: arr)
        
        let session = MockURLSessionRequest(data: response)
        let service = CharacterService(request: session, url: "/character")
        service.getCharacters(success: {[service](response) in
            service.getNextCharacters(nextURL: response?.info.next ?? "", success: {(response2) in
                XCTAssertEqual("/api/character/2", session.url)
                expectation.fulfill()
            }, fail: {(error) in
                XCTAssertEqual("/api/character/2", session.url)
                expectation.fulfill()
            })
            
        }, fail: {(error) in
            XCTFail("Error: \(error)")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testNoDataWhenGetCharacters() {
        let expectation = expectation(description: "get empty character")
        let session = MockURLSessionRequest()
        let service = CharacterService(request: session, url: "/character")
        service.getCharacters(success: {(response) in
            XCTFail("Error: should not have any character")
            expectation.fulfill()
        }, fail: {(error) in
            XCTAssertEqual(HTTPError.noData, error)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetImageSuccessfully() {
        let expectation = expectation(description: "get an image")
        let session = MockURLSessionRequestForImage()
        let service = CharacterService(request: session, url: "/character")
        
        service.getImage(with: "asd.jpg", success: {(response) in
            XCTAssertNotNil(response)
            expectation.fulfill()
        }, fail: {(error) in
            XCTFail("Error: \(error)")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetImageFailed() {
        let expectation = expectation(description: "get an empty image")
        let session = MockURLSessionRequestForImage()
        let service = CharacterService(request: session, url: "/character")
        
        service.getImage(with: "asd", success: {(response) in
            XCTFail("Error: should not success")
            expectation.fulfill()
        }, fail: {(error) in
            XCTAssertEqual(HTTPError.noData, error)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
}

private class MockURLSessionRequestForImage: URLSessionRequestProtocol {
    func request(url: URL, handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if url.pathExtension == "jpg" {
            handler(Data(), nil, nil)
        } else {
            handler(nil, nil, MockError.noInternet)
        }
    }
    
    
}

private enum MockError: Error {
    case noInternet
}

private class MockURLSessionRequest: URLSessionRequestProtocol {
    var data: CharacterResponse? = nil
    var url: String = ""
    init(data: CharacterResponse? = nil) {
        self.data = data
    }
    

    func request(url: URL, handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.url = url.path
        if data != nil {
            guard let data = try? JSONEncoder().encode(data) else {
                handler(nil, nil, MockError.noInternet)
                return
            }
            handler(data, nil, nil)
            return
        }
        handler(nil, nil, MockError.noInternet)
    }
}
