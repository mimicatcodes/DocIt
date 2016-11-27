//
//  TemperatureViewController.swift
//  emeraldHail
//
//  Created by Tanira Wiggins on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class TemperatureViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
     // Tanira: This data is to be used later with the beta version of the application. Please do not remove commented out section below. Thank you :D
    // 0-2 years old rectal thermometer normal is 97.9-100.4 ->Armpit 94.5-99.1 -> Ear 97.5
    // 3-10 years oral thermometer normal is 95.9-99.5 -> Rectal 97.9-100.4-> Armpit 96.6-98.0 -> Ear 97.0-100.0
    // Over age 11 oral thermometer normal is 97.6-99.6 -> rectal 98.6-100.6 -> Armpit 95.3-98.4 -> Ear 96.6-99.7
    
    var availableTemps: [String] = ["96.6", "96.8", "97.0", "97.2", "97.4", "97.6", "97.8", "98.0", "98.2", "98.4", "98.6", "98.8", "99.0", "99.2", "99.4", "99.6", "99.8", "100.0", "100.2", "100.4", "100.6", "100.8", "101.0", "101.2", "101.4", "101.6", "101.8", "102.0", "102.2", "102.4", "102.6", "102.8", "103.0"]
    
    @IBOutlet weak var temperaturePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.temperaturePickerView.delegate = self
        self.temperaturePickerView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    
    
    

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableTemps.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        return availableTemps[row]
        
    }
   

}
