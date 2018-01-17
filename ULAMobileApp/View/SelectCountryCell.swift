//
//  SelectCountryCell.swift
//  ULAMobileApp
//
//  Created by ngovantucuong on 1/17/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class SelectCountryCell: UITableViewCell {
    @IBOutlet weak var nameCountry: UILabel!
    @IBOutlet weak var flagCountry: UILabel!
    
    var country: Country? {
        didSet {
            guard let nameCountry = country?.name else {
                return
            }
            self.nameCountry.text = nameCountry
            self.flagCountry.text = country!.flagCountry
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
