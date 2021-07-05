//
//  SearchTrainPresenterTests.swift
//  MyTravelHelperTests
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper

class SearchTrainPresenterTests: XCTestCase {
    var presenter: SearchTrainPresenter!
    var view = SearchTrainMockView()
    var interactor = SearchTrainInteractorMock()
    
    override func setUp() {
        presenter = SearchTrainPresenter()
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
    }

    func testfetchallStations() {
        presenter.fetchallStations()

        XCTAssertTrue(view.isSaveFetchedStatinsCalled)
    }

    override func tearDown() {
        presenter = nil
    }
}


class SearchTrainMockView:PresenterToViewProtocol {
    
    var isSaveFetchedStatinsCalled = false

    func saveFetchedStations(stations: [Station]?) {
        isSaveFetchedStatinsCalled = true
    }

    func showInvalidSourceOrDestinationAlert() {

    }
    
    func updateLatestTrainList(trainsList: [StationTrain]) {

    }
    
    func showNoTrainsFoundAlert() {

    }
    
    func showNoTrainAvailbilityFromSource() {

    }
    
    func showNoInterNetAvailabilityMessage() {

    }
    
    func saveFetchedStations(stations: [StationName]?) {
        
    }
}

class SearchTrainInteractorMock:PresenterToInteractorProtocol {
    
    var presenter: InteractorToPresenterProtocol?

    func fetchallStations() {
        let station = StationName()
        station.stationId = 228
        station.stationDesc = "Belfast Central"
        station.stationLatitude = 54.6123
        station.stationLongitude = -5.91744
        presenter?.stationListFetched(list: [station])
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String, date: String) {

    }
    
    func updateFaviroteFlagFor(station: StationName) {
        
    }
}
