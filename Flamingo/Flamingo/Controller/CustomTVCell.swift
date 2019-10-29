//
//  CustomTVCell.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 25/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class CustomTVCell: UITableViewCell {

    @IBOutlet weak var typeOfService: UILabel!
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        typeOfService.lineBreakMode = .byWordWrapping
        typeOfService.numberOfLines = 0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
