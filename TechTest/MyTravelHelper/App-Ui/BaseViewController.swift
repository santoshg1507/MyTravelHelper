//
//  BaseViewController.swift
//  MyTravelHelper
//
//  Created by Santosh Gupta on 04/07/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    func dismissKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureActionForDismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapGestureActionForDismissKeyboard() {
        self.view.endEditing(true)
    }
}
