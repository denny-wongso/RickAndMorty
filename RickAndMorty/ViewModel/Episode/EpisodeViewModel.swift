//
//  EpisodeViewModel.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 2/1/23.
//

import Foundation
protocol EpisodeViewModelProtocol {
    var data: [EpisodeModel] {get set}
    func filter(name: String, success: ((Bool, String?) ->Void)?)
    func getEpisodeDetail(id: Int, season: Int, episode: Int) -> EpisodeDetail?
}


public class EpisodeViewModel: EpisodeViewModelProtocol {
    
    var data: [EpisodeModel] = []
    private var allData: [Episode] = []
    private var nextURL: String? = nil
    private var maxRetrieve: Int

    let service: EpisodeApi
    
    init(service: EpisodeApi, maxRetrieve: Int) {
        self.service = service
        self.maxRetrieve = maxRetrieve - 1
    }
    
    
    func filter(name: String, success: ((Bool, String?) ->Void)?) {
        self.data = []
        if name == "" {
            if allData.count == 0 {
                getEpisode(success: {[weak self, success] (s, m) in
                    guard let self = self else {
                        success?(s, m)
                        return
                    }
                    self.data = self.allData.map({self.map(c: $0)})
                    success?(s, m)
                })
            } else {
                getNextPaginationEpisode(success: {[weak self, success] (s, m) in
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
                getNextPaginationEpisode(success: {[weak self, name, success] (s, m) in
                    self?.data = self?.filterData(name: name) ?? []
                    success?(s, m)
                })
            }
        }
    }
    
    private func map(c: Episode) -> EpisodeModel {
        let se = c.episode
        let episodeValue = se.split(separator: "E")
        let episode = Int(episodeValue[1]) ?? 0
        let seasonValue = episodeValue[0].split(separator: "S")
        let season = Int(seasonValue[0]) ?? 0
        return EpisodeModel(id: c.id, name:c.name, season: season, episode: episode, air_date: c.air_date)
    }
    
    private func filterData(name: String) -> [EpisodeModel] {
        var data: [EpisodeModel] = []
        data = self.allData.filter({$0.name.lowercased().contains(name.lowercased())}).map({map(c: $0)})
        return data
    }
    
    func getEpisodeDetail(id: Int, season: Int, episode: Int) -> EpisodeDetail? {
        guard let c = allData.filter({$0.id == id}).first else {
            return nil
        }
        return EpisodeDetail(id: id, name: c.name, air_date: c.air_date, season: season, episode: episode, characters: c.characters, created: c.created)
    }

    private func getEpisode(success: ((Bool, String?) ->Void)?) {
        service.getEpisode(success: {[weak self](episodeResponse) in
            guard let Episode = episodeResponse?.results else {
                success?(false, "no Episode")
                return
            }
            self?.nextURL = episodeResponse?.info.next
            self?.allData.append(contentsOf: Episode)
            success?(true, nil)
        }, fail: {(httperror) in
            success?(false, httperror.localizedDescription)
        })
    }
    
    private func getNextPaginationEpisode(success: ((Bool, String?) ->Void)?) {
        guard let next = nextURL, maxRetrieve > 0 else {
            if maxRetrieve == 0 {
                success?(false, "No more pages")
            } else {
                success?(false, "Invalid url")
            }
            return
        }
        maxRetrieve = maxRetrieve - 1
        service.getNextEpisode(nextURL: next, success: {[weak self](episodeResponse) in
            guard let Episode = episodeResponse?.results else {
                success?(false, "no Episode")
                return
            }
            self?.nextURL = episodeResponse?.info.next
            self?.allData.append(contentsOf: Episode)
            success?(true, nil)
        }, fail: {(httperror) in
            success?(false, httperror.localizedDescription)
        })
    }
}
