//
//  FamilySettingViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class FamilySettingViewController: UIViewController {

    // LOADS
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // ACTIONS 
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
   
    @IBAction func saveSettings(_ sender: UIButton) {
    }
 
    // METHODS
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
