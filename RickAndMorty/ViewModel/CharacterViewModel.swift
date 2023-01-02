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
    func filter(status: String, species: String, gender: String, success: ((Bool, String?) ->Void)?)
    func getCharacterDetail(id: Int, image: Data?) -> CharacterDetail?
}

public class CharacterViewModel: CharacterViewModelProtocol {
    var data: [CharacterModel] = []
    private var allData: [Character] = []
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
                    guard let self = self else {
                        success?(s, m)
                        return
                    }
                    self.data = self.allData.map({self.map(c: $0)})
                    success?(s, m)
                })
            } else {
                getNextPaginationCharacters(success: {[weak self, success] (s, m) in
                    guard let self = self else {
                        success?(s, m)
                        return
                    }
                    self.data = self.allData.map({self.map(c: $0)})
                    success?(s, m)
                })
            }
        } else {
            if(maxRetrieve == 0) {
                self.data = self.filterData(name: name)
                success?(false, nil)
            }
            while maxRetrieve > 0 {
                getNextPaginationCharacters(success: {[weak self, name, success] (s, m) in
                    self?.data = self?.filterData(name: name) ?? []
                    success?(s, m)
                })
            }
        }
    }
    
    private func map(c: Character) -> CharacterModel {
        return CharacterModel(id: c.id, image: c.image, name: c.name, species: c.species.rawValue)
    }
    
    private func filterData(name: String) -> [CharacterModel] {
        var data: [CharacterModel] = []
        data = self.allData.filter({$0.name.lowercased().contains(name.lowercased())}).map({map(c: $0)})
        return data
    }
    
    func filter(status: String, species: String, gender: String, success: ((Bool, String?) ->Void)?) {
        if status == "" && species == "" && gender == "" {
            self.data = allData.map({map(c: $0)})
            success?(true, nil)
            return
        }
        self.data = []
        if(maxRetrieve == 0) {
            self.data = filterData(status: status, species: species, gender: gender)
            success?(true, nil)
        }
        while maxRetrieve > 0 {
            getNextPaginationCharacters(success: {[weak self, status, species, gender, success] (s, m) in
                self?.data = self?.filterData(status: status, species: species, gender: gender) ?? []
                success?(s, m)
            })
        }
    }
    
    func getCharacterDetail(id: Int, image: Data?) -> CharacterDetail? {
        guard let c = allData.filter({$0.id == id}).first else {
            return nil
        }
        return CharacterDetail(id: c.id, image: image, name: c.name, status: c.status, gender: c.gender, species: c.species, created: c.created, origin: c.origin, location: c.location, episode: c.episode)
    }
    
    private func filterData(status: String, species: String, gender: String) -> [CharacterModel] {
        var data: [CharacterModel] = []
        for each in self.allData {
            if status != "" && each.status.rawValue.lowercased().contains(status.lowercased()) == false {
                continue
            }
            if species != "" && each.species.rawValue.lowercased().contains(species.lowercased()) == false {
                continue
            }
            if gender != "" && each.gender.rawValue.lowercased().contains(gender.lowercased()) == false {
                continue
            }
            data.append(map(c: each))
        }
        return data
    }

    private func getCharacters(success: ((Bool, String?) ->Void)?) {
        service.getCharacters(success: {[weak self](characterResponse) in
            guard let characters = characterResponse?.results else {
                success?(false, "no characters")
                return
            }
            self?.nextURL = characterResponse?.info.next
            self?.allData.append(contentsOf: characters)
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
            self?.allData.append(contentsOf: characters)
            success?(true, nil)
        }, fail: {(httperror) in
            success?(false, httperror.localizedDescription)
        })
    }
}
