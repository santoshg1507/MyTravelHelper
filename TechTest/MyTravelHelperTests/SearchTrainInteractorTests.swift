//
//  SearchTrainInteractorTests.swift
//  MyTravelHelperTests
//
//  Created by Santosh Gupta on 04/07/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper

class SearchTrainInteractorTests: XCTestCase {
    
    var interactor: SearchTrainInteractor!
    var presenter = SearchTrainPresenterMock()
    var urlSessionManager: URLSessionManagerProtocol = URLSessionManagerMock()
    var view = SearchTrainMockView()

    override func setUp() {
        interactor = SearchTrainInteractor()
        interactor.presenter = presenter
        interactor.urlSessionManager = urlSessionManager
    }
    
    func testfetchallStations() {
        interactor.fetchallStations()
        XCTAssert((interactor.presenter?.stationsList.count ?? 0) > 0 , "failed to get station")
    }
    
    func testFetchTrainsFromSource() {
        let source = "BFSTC"
        let destination = "LBURN"
        let expectation = self.expectation(description: "get train")
        interactor.fetchTrainsFromSource(sourceCode: source, destinationCode: destination, date: Date().string(withFormat: "dd/MM/yyyy"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
            XCTAssert((self.interactor.presenter?.trainList?.count ?? 0) > 0 , "failed to get train")
        }
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    override func tearDown() {
        interactor = nil
    }
}

class SearchTrainPresenterMock: InteractorToPresenterProtocol {
    
    var stationsList:[Station] = [Station]()
    var trainList:[StationTrain]?

    func stationListFetched(list:[Station]) {
        self.stationsList = list
    }
    func fetchedTrainsList(trainsList:[StationTrain]?) {
        self.trainList = trainsList
    }
    func showNoTrainAvailbilityFromSource() {
        
    }
    func showNoInterNetAvailabilityMessage() {
        
    }
}
