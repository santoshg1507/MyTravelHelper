//
//  StationTableViewCell.swift
//  MyTravelHelper
//
//  Created by Santosh Gupta on 05/07/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import UIKit

protocol StationTableViewCellDelegate: class {
    func updateFaviroteFlagForStation(station: StationName)
}

class StationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationCodeLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!

    weak var delegate: StationTableViewCellDelegate?
    weak  var station: StationName?
}

extension StationTableViewCell {
    
    func configureCell(station: StationName) {
        self.station = station
        self.stationNameLabel.text = station.stationDesc
        self.stationCodeLabel.text = station.stationCode
        self.favouriteButton.isSelected = station.favorite
    }
    
    @IBAction func onTappedFaviroteBtn() {
        if let station = self.station {
            self.delegate?.updateFaviroteFlagForStation(station: station)
        }
    }
    
}

