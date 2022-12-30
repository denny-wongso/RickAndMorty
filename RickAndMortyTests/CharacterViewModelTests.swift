//
//  CharacterViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Denny Wongso on 30/12/22.
//

import XCTest
@testable import RickAndMorty

class CharacterViewModelTests: XCTestCase {
    
    func testSuccessfullyGetCharacters() {
        let expectation = expectation(description: "get characters")
        let service = MockCharacterApi(isSuccess: true, cr: generateCR())
        let cvm = CharacterViewModel(service: service, maxRetrieve: 10)
        cvm.getCharacters(success: {(status, message) in
            XCTAssertEqual(status, true)
            XCTAssertEqual(cvm.data.count, service.cr.results?.count)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testSuccessFullyGetCharactersTwiceWithMaxRetryTwo() {
        let expectation = expectation(description: "get characters twice")
        let service = MockCharacterApi(isSuccess: true, cr: generateCR())
        let cvm = CharacterViewModel(service: service, maxRetrieve: 2)
        cvm.getCharacters(success: {(status, message) in
            cvm.getNextPaginationCharacters(success: {(status, message) in
                XCTAssertEqual(status, true)
                let c = service.cr.results?.count ?? 0
                XCTAssertEqual(cvm.data.count, c * 2)
                expectation.fulfill()
            })
        })
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testFailWhenGetCharactersThriceWithMaxRetryTwo() {
        let expectation = expectation(description: "get characters thrice with error")
        let service = MockCharacterApi(isSuccess: true, cr: generateCR())
        let cvm = CharacterViewModel(service: service, maxRetrieve: 2)
        cvm.getCharacters(success: {(status, message) in
            cvm.getNextPaginationCharacters(success: {(status, message) in
                cvm.getNextPaginationCharacters(success: {(status, message) in
                    XCTAssertEqual(status, false)
                    XCTAssertEqual(message, "No more pages")
                    expectation.fulfill()
                })
            })
        })
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    //HELPER
    func generateCR() -> CharacterResponse {
        let i = Info(count: 10, pages: 1, next: "a", prev: nil)
        let c1 = Character(id: 1, name: "a", status: .Alive, species: .Alien, type: "a", gender: .Male, origin: .init(name: "a", url: "a"), location: .init(name: "a", url: "a"), image: "a", episode: ["a"], url: "a", created: "a")
        let c2 = Character(id: 1, name: "a", status: .Alive, species: .Alien, type: "a", gender: .Male, origin: .init(name: "a", url: "a"), location: .init(name: "a", url: "a"), image: "a", episode: ["a"], url: "a", created: "a")
        let cr = CharacterResponse(info: i, results: [c1, c2])
        return cr
    }
    
}

private class MockCharacterApi: CharacterApi {
    var isSuccess: Bool = true
    var cr: CharacterResponse
    init(isSuccess: Bool, cr: CharacterResponse) {
        self.isSuccess = isSuccess
        self.cr = cr
    }
    func getCharacters(success: ((CharacterResponse?) -> Void)?, fail: ((HTTPError) -> Void)?) {
        if isSuccess {
            success?(self.cr)
        } else {
            fail?(HTTPError.noData)
        }
    }
    
    func getNextCharacters(nextURL: String, success: ((CharacterResponse?) -> Void)?, fail: ((HTTPError) -> Void)?) {
        if isSuccess {
            success?(self.cr)
        } else {
            fail?(HTTPError.noData)
        }
    }
    
    func getImage(with path: String, success: ((Data?) -> Void)?, fail: ((HTTPError) -> Void)?) {
        if isSuccess {
            success?(Data())
        } else {
            fail?(HTTPError.noData)
        }
    }
    
    
}
