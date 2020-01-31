//
//  CustomTVCells.swift
//  Flamingo
//
//  Created by mac on 09/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit

class CustomTVCellSample: UITableViewCell {

    
    @IBOutlet weak var iconPrice: UIImageView!
    @IBOutlet weak var iconTime: UIImageView!
    @IBOutlet weak var nameService: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var timeService: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameService.lineBreakMode = .byWordWrapping
        nameService.numberOfLines = 0
        //viewBackground.layer.cornerRadius = 40
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
    var serviceDiscount = ""
    @IBOutlet weak var newDiscont: UILabel!{
        didSet{
            newDiscont.textColor = .orange
        }
    }
    @IBOutlet weak var textLook: SetupLabel!{
        didSet{
            textLook.text = "  Смотреть  "
            textLook.layer.cornerRadius = textLook.frame.size.width * 0.05
            textLook.layer.borderWidth = BorderWidth.borderWidth
            textLook.layer.borderColor = ColorApp.white.cgColor
        }
    }
    @IBOutlet weak var nameDiscont: SetupLabel!
    @IBOutlet weak var descriptionDiscount: SetupLabel!
    @IBOutlet weak var imageDiscont: UIImageView!{
        didSet{
            imageDiscont.layer.cornerRadius = imageDiscont.frame.size.width * 0.01
            imageDiscont.contentMode = .scaleToFill
        }
    }
    
    @IBOutlet weak var buttonAlertInfo: UIButton!
    @IBOutlet weak var info: SetupLabel!
}


class CustomTVCellMaster: UITableViewCell{
    
    @IBOutlet weak var nameMaster: UILabel!
    @IBOutlet weak var profilMaster: UILabel!
    @IBOutlet weak var imageMaster: UIImageView!{
        didSet{
            imageMaster.layer.cornerRadius = imageMaster.frame.size.width/2
            imageMaster.contentMode = .scaleToFill
        }
    }
}


class MasterTVCell: UITableViewCell{
    
    @IBOutlet weak var imageMaster: UIImageView!{
        didSet{
            imageMaster.layer.cornerRadius = imageMaster.frame.size.width/2
        }
    }
    @IBOutlet weak var nameMaster: UILabel!
    @IBOutlet weak var profilMaster: UILabel!
    @IBOutlet weak var timeAndPrice: UILabel!
    
}

class CategoryTVCell: UITableViewCell{
    
    
    @IBOutlet weak var imageCategory: UIImageView!{
        didSet{
            imageCategory.contentMode = .scaleAspectFill
            imageCategory.layer.cornerRadius = imageCategory.frame.size.width * 0.01
        }
    }
    @IBOutlet weak var nameCategory: UILabel!
    
}

class ServiceEnryTVCell: UITableViewCell{
    
    
    @IBOutlet weak var nameService: UILabel!
    @IBOutlet weak var labelMaster: UILabel!
    @IBOutlet weak var nameMaster: UILabel!
    
    @IBOutlet weak var timeServiceEntry: UILabel!
    @IBOutlet weak var buttonCancellation: UIButton!
    @IBOutlet weak var buttonOverwrite: UIButton!
    @IBOutlet weak var viewServiceEntry: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewServiceEntry.layer.cornerRadius = self.viewServiceEntry.frame.size.width * 0.01
        //self.viewServiceEntry.backgroundColor = ColorApp.indigo.withAlphaComponent(1)
    }
    
    func diactivate(){
        self.nameService.alpha = 0.3
        self.labelMaster.alpha = 0.3
        self.nameMaster.alpha = 0.3
        
        self.timeServiceEntry.alpha = 0.3
        self.buttonCancellation.alpha = 0.3
        self.buttonCancellation.isUserInteractionEnabled = false
        self.buttonOverwrite.alpha = 0.3
        self.buttonCancellation.isUserInteractionEnabled = false
    }
    
    func activate(){
        self.nameService.alpha = 1
        self.labelMaster.alpha = 1
        self.nameMaster.alpha = 1
        
        self.timeServiceEntry.alpha = 1
        self.buttonCancellation.alpha = 1
        self.buttonCancellation.isUserInteractionEnabled = true
        self.buttonOverwrite.alpha = 1
        self.buttonCancellation.isUserInteractionEnabled = true
    }
    
}
