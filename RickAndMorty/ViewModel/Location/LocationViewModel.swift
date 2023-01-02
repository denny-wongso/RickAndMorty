//
//  LocationViewModel.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 2/1/23.
//

import Foundation


protocol LocationViewModelProtocol {
    var data: [LocationModel] {get set}
    func filter(name: String, success: ((Bool, String?) ->Void)?)
    func getLocationDetail(id: Int) -> LocationDetail?
}


public class LocationViewModel: LocationViewModelProtocol {
    
    var data: [LocationModel] = []
    private var allData: [Location] = []
    private var nextURL: String? = nil
    private var maxRetrieve: Int

    let service: LocationApi
    
    init(service: LocationApi, maxRetrieve: Int) {
        self.service = service
        self.maxRetrieve = maxRetrieve - 1
    }
    
    
    func filter(name: String, success: ((Bool, String?) ->Void)?) {
        self.data = []
        if name == "" {
            if allData.count == 0 {
                getLocation(success: {[weak self, success] (s, m) in
                    guard let self = self else {
                        success?(s, m)
                        return
                    }
                    self.data = self.allData.map({self.map(c: $0)})
                    success?(s, m)
                })
            } else {
                getNextPaginationLocation(success: {[weak self, success] (s, m) in
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
                getNextPaginationLocation(success: {[weak self, name, success] (s, m) in
                    self?.data = self?.filterData(name: name) ?? []
                    success?(s, m)
                })
            }
        }
    }
    
    private func map(c: Location) -> LocationModel {
        return LocationModel(id: c.id, name: c.name, type: c.type, dimension: c.dimension)
    }
    
    private func filterData(name: String) -> [LocationModel] {
        var data: [LocationModel] = []
        data = self.allData.filter({$0.name.lowercased().contains(name.lowercased())}).map({map(c: $0)})
        return data
    }
    
    func getLocationDetail(id: Int) -> LocationDetail? {
        guard let c = allData.filter({$0.id == id}).first else {
            return nil
        }
        return LocationDetail(id: c.id, name: c.name, type: c.type, dimension: c.dimension, residents: c.residents, created: c.created)
    }

    private func getLocation(success: ((Bool, String?) ->Void)?) {
        service.getLocation(success: {[weak self](locationResponse) in
            guard let location = locationResponse?.results else {
                success?(false, "no location")
                return
            }
            self?.nextURL = locationResponse?.info.next
            self?.allData.append(contentsOf: location)
            success?(true, nil)
        }, fail: {(httperror) in
            success?(false, httperror.localizedDescription)
        })
    }
    
    private func getNextPaginationLocation(success: ((Bool, String?) ->Void)?) {
        guard let next = nextURL, maxRetrieve > 0 else {
            if maxRetrieve == 0 {
                success?(false, "No more pages")
            } else {
                success?(false, "Invalid url")
            }
            return
        }
        maxRetrieve = maxRetrieve - 1
        service.getNextLocation(nextURL: next, success: {[weak self](locationResponse) in
            guard let location = locationResponse?.results else {
                success?(false, "no location")
                return
            }
            self?.nextURL = locationResponse?.info.next
            self?.allData.append(contentsOf: location)
            success?(true, nil)
        }, fail: {(httperror) in
            success?(false, httperror.localizedDescription)
        })
    }
}
