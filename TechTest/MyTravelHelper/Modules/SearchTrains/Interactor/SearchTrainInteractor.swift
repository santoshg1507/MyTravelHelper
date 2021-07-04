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
    
    var urlSessionManager: URLSessionManagerProtocol = URLSessionManager()

    func fetchallStations() {
        if Reach().isNetworkReachable() == true {
            let url = URLConstants.getAllStationsXML
            urlSessionManager.getApi(url: url) { (statusCode, data, error)  in
                if let data = data {
                    do {
                        let station = try XMLDecoder().decode(Stations.self, from: data)
                        self.presenter!.stationListFetched(list: station.stationsList)
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

    func fetchTrainsFromSource(sourceCode:String,destinationCode:String, date: String) {
        _sourceStationCode = sourceCode
        _destinationStationCode = destinationCode
        let urlString = URLConstants.getStationDataByCodeXML_withParam.addUrlParam(parameters: [sourceCode]) 
        if Reach().isNetworkReachable() {
            urlSessionManager.getApi(url: urlString) { (statusCode, data, error)  in
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
                    self.presenter!.stationListFetched(list: [])
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
            group.enter()
            let urlString = URLConstants.getTrainMovementsXML_withParam.addUrlParam(parameters: [trainsList[index].trainCode,date])
            if Reach().isNetworkReachable() {
                urlSessionManager.getApi(url: urlString) { (statusCode, data, error)  in
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
