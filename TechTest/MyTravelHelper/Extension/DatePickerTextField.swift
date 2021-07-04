//
//  DatePickerTextField.swift
//  MyTravelHelper
//
//  Created by Santosh Gupta on 04/07/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import UIKit

protocol DatePickerTextFieldDelegate:class {
    func getDate(_ datePickerTextField:DatePickerTextField, date:Date)
}

class DatePickerTextField: UITextField {
    
    private let datePicker = UIDatePicker()
    weak var selectionDelegate: DatePickerTextFieldDelegate?
    
    var maxDate: Date? {
        didSet {
            datePicker.maximumDate = maxDate
        }
    }
    
    var minDate: Date? {
        didSet {
            datePicker.minimumDate = minDate
        }
    }
    
    var dateFormat: String = "dd-MMM-yyyy"
    
    var datePickerMode: UIDatePicker.Mode = .date {
        didSet {
            datePicker.datePickerMode = datePickerMode
        }
    }
    
    var selectedDate: Date {
        set {
            self.text = newValue.string(withFormat: self.dateFormat)
        }
        get {
            return self.datePicker.date
        }
    }
    
    override func awakeFromNib() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.inputView = datePicker
        self.delegate = self
    }
    
    func addToolbar() {
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action:       #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem:       UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated:false)
        
        self.inputAccessoryView = toolbar
        
    }
    
    func setupDatePickerTextField(mode: UIDatePicker.Mode, dateformat: String, maxDate: Date, minDate: Date, selectionDelegate: DatePickerTextFieldDelegate?) {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.delegate = self
        self.dateFormat = dateformat
        self.datePickerMode = mode
        self.maxDate = maxDate
        self.minDate = minDate
        self.selectionDelegate = selectionDelegate
        self.inputView = datePicker
        
    }

    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = self.dateFormat
        let result = formatter.string(from: selectedDate)
        self.text = result
        self.selectionDelegate?.getDate(self, date: datePicker.date)
        
    }
    
}

extension DatePickerTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.donedatePicker()
    }
    
}
