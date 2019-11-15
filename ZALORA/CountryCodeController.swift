//
//  CountryCodeController.swift
//  ZALORA
//
//  Created by Afnan Khan on 11/7/19.
//  Copyright © 2019 Afnan Khan. All rights reserved.
//

import UIKit

class CountryCodeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   @IBAction func countryCodePickerButtonClicked(_ sender: UIButton) {
    
    
     let picker = ADCountryPicker(style: .grouped)
            // delegate
            picker.delegate = self

            // Display calling codes
            picker.showCallingCodes = true

            // or closure
            picker.didSelectCountryClosure = { name, code in
                _ = picker.navigationController?.popToRootViewController(animated: true)
                print(code)
            }
            
            
    //        Use this below code to present the picker
            
            let pickerNavigationController = UINavigationController(rootViewController: picker)
            self.present(pickerNavigationController, animated: true, completion: nil)
    
    
    }

}


extension CountryCodeController: ADCountryPickerDelegate {
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        _ = picker.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
         
        
       let x =  picker.getFlag(countryCode: code)
        let xx =  picker.getCountryName(countryCode: code)
        let xxx =  picker.getDialCode(countryCode: code)
    }
}
