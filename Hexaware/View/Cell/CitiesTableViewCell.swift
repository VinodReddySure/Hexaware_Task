//
//  CitiesTableViewCell.swift
//  Hexaware
//
//  Created by Vinod Reddy Sure on 05/01/21.
//  Copyright © 2020 Vinod Reddy Sure. All rights reserved.
//

import UIKit

class CitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelCountry: UILabel!
    @IBOutlet weak var btnBookMark: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
