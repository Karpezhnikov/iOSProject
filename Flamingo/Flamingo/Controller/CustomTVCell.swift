//
//  CustomTVCell.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 25/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class CustomTVCell: UITableViewCell {

    @IBOutlet weak var nameService: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var timeService: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameService.lineBreakMode = .byWordWrapping
        nameService.numberOfLines = 0
        
        //self.layer.borderWidth = 1
        //self.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
