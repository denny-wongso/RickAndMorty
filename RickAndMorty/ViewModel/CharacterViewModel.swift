//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 30/12/22.
//

import Foundation

protocol CharacterViewModelProtocol {
    var data: [CharacterModel] {get set}
    func getImage(path: String, data: ((Data?) ->Void)?)
    func filter(name: String, success: ((Bool, String?) ->Void)?)
}

public class CharacterViewModel: CharacterViewModelProtocol {
    var data: [CharacterModel] = []
    private var allData: [CharacterModel] = []
    private var nextURL: String? = nil
    private var maxRetrieve: Int

    let service: CharacterApi
    
    init(service: CharacterApi, maxRetrieve: Int) {
        self.service = service
        self.maxRetrieve = maxRetrieve - 1
    }
    
    func getImage(path: String, data: ((Data?) ->Void)?) {
        service.getImage(with: path, success: data, fail: nil)
    }
    
    func filter(name: String, success: ((Bool, String?) ->Void)?) {
        self.data = []
        if name == "" {
            if allData.count == 0 {
                getCharacters(success: {[weak self, success] (s, m) in
                    self?.data = self?.allData ?? []
                    success?(s, m)
                })
            } else {
                getNextPaginationCharacters(success: {[weak self, success] (s, m) in
                    self?.data = self?.allData ?? []
                    success?(s, m)
                })
            }
        } else {
            if(maxRetrieve == 0) {
                self.data = self.allData.filter({$0.name.lowercased().contains(name.lowercased())})
                success?(true, nil)
            }
            while maxRetrieve > 0 {
                getNextPaginationCharacters(success: {[weak self, name, success] (s, m) in
                    self?.data = self?.allData.filter({$0.name.lowercased().contains(name.lowercased())}) ?? []
                    success?(s, m)
                })
            }
        }
    }

    private func getCharacters(success: ((Bool, String?) ->Void)?) {
        service.getCharacters(success: {[weak self](characterResponse) in
            guard let characters = characterResponse?.results else {
                success?(false, "no characters")
                return
            }
            self?.nextURL = characterResponse?.info.next
            self?.allData.append(contentsOf: characters.map{ CharacterModel(image: $0.image, name: $0.name, species: $0.species.rawValue) })
            success?(true, nil)
        }, fail: {(httperror) in
            success?(false, httperror.localizedDescription)
        })
    }
    
    private func getNextPaginationCharacters(success: ((Bool, String?) ->Void)?) {
        guard let next = nextURL, maxRetrieve > 0 else {
            if maxRetrieve == 0 {
                success?(false, "No more pages")
            } else {
                success?(false, "Invalid url")
            }
            return
        }
        maxRetrieve = maxRetrieve - 1
        service.getNextCharacters(nextURL: next, success: {[weak self](characterResponse) in
            guard let characters = characterResponse?.results else {
                success?(false, "no characters")
                return
            }
            self?.nextURL = characterResponse?.info.next
            self?.allData.append(contentsOf: characters.map{ CharacterModel(image: $0.image, name: $0.name, species: $0.species.rawValue) })
            success?(true, nil)
        }, fail: {(httperror) in
            success?(false, httperror.localizedDescription)
        })
    }
}
