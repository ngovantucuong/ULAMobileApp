//
//  SelectCountryView.swift
//  ULAMobileApp
//
//  Created by ngovantucuong on 1/17/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class SelectCountryView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var countrys: [Country]?
    let cellid = "cellid"
    var inputNumberPhoneView: InputNumberPhoneView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextfield.delegate = self
        searchTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        tableView.delegate = self
        tableView.dataSource = self
        
        let uiNib = UINib(nibName: "SelectCountryCell", bundle: nil)
        tableView.register(uiNib, forCellReuseIdentifier: cellid)
        
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange() {
        self.countrys = (self.countrys?.filter({ (item) -> Bool in
            let countryText: NSString = item.name as NSString
            
            return (countryText.range(of: searchTextfield.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        }))!
        
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countrys?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! SelectCountryCell
        let country = countrys?[indexPath.item]
        cell.country = country
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countrys![indexPath.item]
        self.inputNumberPhoneView?.dialCodeLabel.text = country.dial_code
        self.dismiss(animated: true, completion: nil)
    }
}
