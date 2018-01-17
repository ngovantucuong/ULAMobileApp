//
//  InputNumberPhoneView.swift
//  ULAMobileApp
//
//  Created by ngovantucuong on 1/16/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class InputNumberPhoneView: UIViewController {

    @IBOutlet weak var bottomConstraintForwardAction: NSLayoutConstraint!
    var countryData: [Country]?
    @IBOutlet weak var dialCodeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCountryDataFrom(url: "https://api.myjson.com/bins/z2r8t")
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            bottomConstraintForwardAction.constant = keyboardHeight + 30
        }
    }
    
    func getCountryDataFrom(url: String) {
        ApiService.shareInstance.fetchDataJsonFrom(url: url, complete: { (country: [Country]) in
            self.countryData = country
        })
    }

    @IBAction func ShowSelectCountry(_ sender: Any) {
        performSegue(withIdentifier: "showSelectCountry", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSelectCountry" {
            let selectCountryView = segue.destination as? SelectCountryView
            selectCountryView?.countrys = countryData
            selectCountryView?.inputNumberPhoneView = self
        }
    }
}
