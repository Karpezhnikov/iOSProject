//
//  RuleTVC.swift
//  GamesTeam
//
//  Created by kam_team on 21.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

class RuleTVC: UITableViewCell {

    
    @IBOutlet weak var ruleView: UIView!
    @IBOutlet weak var ruleInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.ruleInfo.font = UIFont(name: FontApp.markerThin, size: 20)
        self.ruleInfo.textColor = ColorApp.blackApp
        
        self.ruleView.backgroundColor = ColorApp.whiteApp
        self.ruleView.layer.cornerRadius = SettingsApp.cornerRadius
        self.ruleView.layer.shadowColor = UIColor.black.cgColor
        self.ruleView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.ruleView.layer.shadowRadius = 5.0
        self.ruleView.layer.shadowOpacity = 0.4
        self.ruleView.layer.masksToBounds = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
