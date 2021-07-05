//
//  SearchTrainPresenter.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

class SearchTrainPresenter:ViewToPresenterProtocol {
    var stationsList:[StationName] = [StationName]()
    var trainList:[StationTrain]?

    func searchTapped(source: String, destination: String, date: String) {
        let sourceStationCode = source
        let destinationStationCode = destination
        interactor?.fetchTrainsFromSource(sourceCode: sourceStationCode, destinationCode: destinationStationCode, date: date)
    }
    
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
    var view:PresenterToViewProtocol?

    func fetchallStations() {
        interactor?.fetchallStations()
    }

    private func getStationCode(stationName:String)->String {
        let stationCode = stationsList.filter{$0.stationDesc == stationName}.first
        return stationCode?.stationCode?.lowercased() ?? ""
    }
}

extension SearchTrainPresenter: InteractorToPresenterProtocol {
        
    func showNoInterNetAvailabilityMessage() {
        view!.showNoInterNetAvailabilityMessage()
    }

    func showNoTrainAvailbilityFromSource() {
        view!.showNoTrainAvailbilityFromSource()
    }

    func fetchedTrainsList(trainsList: [StationTrain]?) {
        if let _trainsList = trainsList {
            self.trainList = _trainsList
            view!.updateLatestTrainList(trainsList: _trainsList)
        }else {
            view!.showNoTrainsFoundAlert()
        }
    }
    
    func stationListFetched(list: [StationName]) {
        stationsList = list
        view!.saveFetchedStations(stations: list)
    }
    
    func updateFaviroteFlagFor(station: StationName) {
        interactor?.updateFaviroteFlagFor(station: station)
    }
}
