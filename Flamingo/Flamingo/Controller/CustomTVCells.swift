//
//  CustomTVCell.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 25/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class CustomTVCellSample: UITableViewCell {

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

class CustomTVCellDetail: UITableViewCell {
    
    @IBOutlet weak var nameMaster: UILabel!
    @IBOutlet weak var serviceMaster: UILabel!
    @IBOutlet weak var timeAndPriceMaster: UILabel!
    @IBOutlet weak var photoMaster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoMaster.layer.cornerRadius = photoMaster.frame.size.width / 2
        
        //self.layer.borderWidth = 1
        //self.layer.cornerRadius = 10
    }
}

class CustomTVCellDiscont: UITableViewCell{
    var nameDiscount = ""  // название акции
    var serviceDiscount = ""
    var descriptionDiscount = "" // описание акции
    
    @IBOutlet weak var imageDiscont: UIImageView!{
        didSet{
            imageDiscont.layer.cornerRadius = 40
            imageDiscont.contentMode = .scaleToFill
        }
    }
}


class CustomTVCellMaster: UITableViewCell{
    
    @IBOutlet weak var nameMaster: UILabel!
    @IBOutlet weak var profilMaster: UILabel!
    @IBOutlet weak var imageMaster: UIImageView!
}
