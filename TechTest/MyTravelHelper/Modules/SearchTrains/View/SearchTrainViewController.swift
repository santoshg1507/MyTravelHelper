//
//  SearchTrainViewController.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit
import SwiftSpinner
import DropDown

class SearchTrainViewController: BaseViewController {
    
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var sourceTxtField: UITextField!
    @IBOutlet weak var dateTxtField: DatePickerTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sourceBtn: UIButton!
    @IBOutlet weak var destinationBtn: UIButton!
    @IBOutlet weak var dateBtn: UIButton!

    var stationNameList:[StationName] = [StationName]()
    var trains:[StationTrain] = [StationTrain]()
    var presenter:ViewToPresenterProtocol?
    var transitPoints:(source:String,destination:String) = ("","")
    var selectedStation: UIButton?
    var searchFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePickerSetup()
        self.tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        if stationNameList.count == 0 {
            SwiftSpinner.useContainerView(view)
            SwiftSpinner.show("general.loadingStation".localized())
            presenter?.fetchallStations()
        }
    }

    @IBAction func searchTrainsTapped(_ sender: Any) {
        self.searchFlag = true
        self.tableView.reloadData()
        self.sourceBtn.backgroundColor = UIColor.clear
        self.destinationBtn.backgroundColor = UIColor.clear
        self.dateBtn.backgroundColor = UIColor.clear
        showProgressIndicator(view: self.view)
        presenter?.searchTapped(source: transitPoints.source, destination: transitPoints.destination, date: dateTxtField.selectedDate.string(withFormat: "dd/MM/yyyy"))
    }
}

extension SearchTrainViewController:PresenterToViewProtocol {
    
    func showNoInterNetAvailabilityMessage() {
        hideProgressIndicator(view: self.view)
        showAlert(title: "general.noInternet".localized(), message: "general.internetIssue".localized(), actionTitle: "general.Okay".localized())
    }

    func showNoTrainAvailbilityFromSource() {
        hideProgressIndicator(view: self.view)
        showAlert(title: "searchTrain.noTrain".localized(), message: "searchTrain.noTrainArrivingIn90min".localized(), actionTitle: "general.Okay".localized())
    }

    func updateLatestTrainList(trainsList: [StationTrain]) {
        hideProgressIndicator(view: self.view)
        trains = trainsList
        tableView.reloadData()
    }

    func showNoTrainsFoundAlert() {
        hideProgressIndicator(view: self.view)
        showAlert(title: "searchTrain.noTrain".localized(), message: "searchTrain.noTrainFromSourceDestiIn90min".localized(), actionTitle: "general.Okay".localized())
    }

    func showAlert(title:String,message:String,actionTitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showInvalidSourceOrDestinationAlert() {
        hideProgressIndicator(view: self.view)
        showAlert(title: "searchTrain.invalidSourceDesti".localized(), message: "searchTrain.validationSourceDesti".localized(), actionTitle: "general.Okay".localized())
    }

    func saveFetchedStations(stations: [StationName]?) {
        if let _stations = stations {
          self.stationNameList = _stations
            let arr1 = self.stationNameList.filter( { $0.favorite })
            let arr2 = self.stationNameList.filter( { !$0.favorite })
            self.stationNameList = arr1 + arr2
        }
        self.tableView.reloadData()
        SwiftSpinner.hide()
    }
}

extension SearchTrainViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchFlag {
            return trains.count
        }
        else {
            return stationNameList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchFlag {
            let cell = tableView.dequeueReusableCell(withIdentifier: TrainInfoCell.className, for: indexPath) as! TrainInfoCell
            let train = trains[indexPath.row]
            cell.configureCell(train: train)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: StationTableViewCell.className, for: indexPath) as! StationTableViewCell
            let station = self.stationNameList[indexPath.row]
            cell.configureCell(station: station)
            cell.delegate = self
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = self.stationNameList[indexPath.row]
        if self.selectedStation?.tag == 0 {
            self.sourceTxtField.text = station.stationDesc
            self.transitPoints.source = station.stationCode ?? ""
            self.onTappedTextFieldBtn(sender: self.destinationBtn)
        }
        else if self.selectedStation?.tag == 1 {
            self.destinationTextField.text = station.stationDesc
            self.transitPoints.destination = station.stationCode ?? ""
            if self.dateTxtField.text!.isEmpty {
                self.dateTxtField.selectedDate = Date()
            }
        }
        else {
            
        }
        
    }
}

//MARK: datepicker setup for date selection
extension SearchTrainViewController {
    
    func datePickerSetup() {
        dateTxtField.setupDatePickerTextField(mode: .date, dateformat: "dd-MMM-yyyy", maxDate: Date().addDays(60), minDate: Date().addDays(-1) , selectionDelegate: nil)
        dateTxtField.addToolbar()
        self.onTappedTextFieldBtn(sender: self.sourceBtn)
    }
    
}

//MARK: TextField selection function
extension SearchTrainViewController {
    
    @IBAction func onTappedTextFieldBtn(sender: UIButton) {
        if sender.tag == 0 {
            self.sourceBtn.backgroundColor = UIColor.cyan.withAlphaComponent(0.2)
            self.destinationBtn.backgroundColor = UIColor.clear
            self.dateBtn.backgroundColor = UIColor.clear
            self.selectedStation = sender
        }
        else if sender.tag == 1 {
            self.destinationBtn.backgroundColor = UIColor.cyan.withAlphaComponent(0.2)
            self.sourceBtn.backgroundColor = UIColor.clear
            self.dateBtn.backgroundColor = UIColor.clear
            self.selectedStation = sender
        }
        else {
            self.dateBtn.backgroundColor = UIColor.cyan.withAlphaComponent(0.2)
            self.sourceBtn.backgroundColor = UIColor.clear
            self.destinationBtn.backgroundColor = UIColor.clear
            self.selectedStation = sender
            self.dateTxtField.becomeFirstResponder()
        }
        self.searchFlag = false
        self.tableView.reloadData()
    }
}

//MARK: update favirote flag function
extension SearchTrainViewController: StationTableViewCellDelegate {
    
    func updateFaviroteFlagForStation(station: StationName) {
        self.presenter?.updateFaviroteFlagFor(station: station)
        self.tableView.reloadData()
    }

}
