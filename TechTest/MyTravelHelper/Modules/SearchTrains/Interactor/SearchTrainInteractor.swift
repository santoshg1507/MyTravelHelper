//
//  SearchTrainInteractor.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation
import XMLParsing

class SearchTrainInteractor: PresenterToInteractorProtocol {
    var _sourceStationCode = String()
    var _destinationStationCode = String()
    var presenter: InteractorToPresenterProtocol?
    let coreDataManager = CoreDataManager.shared()

    var urlSessionManager: URLSessionManagerProtocol = URLSessionManager()

    func fetchallStations() {
        let stations = self.fetchStationsFromCoreData()
        if stations.count > 0 {
            self.presenter!.stationListFetched(list: stations)
        }
        else {
            if Reach().isNetworkReachable() == true {
                urlSessionManager.api(request: StationTrainRouter.getAllStations) { (statusCode, data, error)  in
                    if let data = data {
                        do {
                            let station = try XMLDecoder().decode(Stations.self, from: data)
                            let cd_stations = self.saveStationToCoreData(stations: station.stationsList)
                            self.presenter!.stationListFetched(list: cd_stations)
                        }
                        catch (let error) {
                            print(error.localizedDescription)
                            DispatchQueue.main.async {
                                self.presenter!.stationListFetched(list: [])
                            }
                        }
                    }
                    else {
                        self.presenter!.stationListFetched(list: [])
                    }
                }
            } else {
                self.presenter!.showNoInterNetAvailabilityMessage()
            }
        }
    }

    func fetchTrainsFromSource(sourceCode:String,destinationCode:String, date: String) {
        _sourceStationCode = sourceCode
        _destinationStationCode = destinationCode
        if Reach().isNetworkReachable() {
            urlSessionManager.api(request: StationTrainRouter.getStationDataByCode(stationCode: sourceCode)) { (statusCode, data, error)  in
                if let data = data {
                    do {
                        let stationData = try XMLDecoder().decode(StationData.self, from: data)
                        let _trainsList = stationData.trainsList
                        self.proceesTrainListforDestinationCheck(trainsList: _trainsList, date: date)
                    }
                    catch (let error) {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            self.presenter!.showNoTrainAvailbilityFromSource()
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.presenter!.showNoTrainAvailbilityFromSource()
                    }
                }
            }
        } else {
            self.presenter!.showNoInterNetAvailabilityMessage()
        }
    }
    
    private func proceesTrainListforDestinationCheck(trainsList: [StationTrain], date: String) {
        var _trainsList = trainsList
        let group = DispatchGroup()
        
        for index  in 0..<trainsList.count {
            if Reach().isNetworkReachable() {
                group.enter()
                urlSessionManager.api(request: StationTrainRouter.getTrainMovements(trainId: trainsList[index].trainCode, trainDate: date)) { (statusCode, data, error)  in
                    if let data = data {
                        do {
                            
                            let trainMovements = try XMLDecoder().decode(TrainMovementsData.self, from: data)
                            
                            let _movements = trainMovements.trainMovements
                            let sourceIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._sourceStationCode) == .orderedSame})
                            let destinationIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame})
                            let desiredStationMoment = _movements.filter{$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame}
                            let isDestinationAvailable = desiredStationMoment.count == 1
                            
                            if isDestinationAvailable  && sourceIndex! < destinationIndex! {
                                _trainsList[index].destinationDetails = desiredStationMoment.first
                            }
                        }
                        catch (let error) {
                            print(error.localizedDescription)
                        }
                    }
                    group.leave()
                }
            } else {
                self.presenter!.showNoInterNetAvailabilityMessage()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            let sourceToDestinationTrains = _trainsList.filter{$0.destinationDetails != nil}
            self.presenter!.fetchedTrainsList(trainsList: sourceToDestinationTrains)
        }
    }
}

extension SearchTrainInteractor {
    private func saveStationToCoreData(stations: [Station]) -> [StationName] {
        return self.coreDataManager.saveStations(stations: stations)
    }
    
    private func fetchStationsFromCoreData() -> [StationName] {
        return coreDataManager.getStations()
    }
    
    func updateFaviroteFlagFor(station: StationName) {
        station.favorite = !station.favorite
        coreDataManager.saveData()
    }
}

