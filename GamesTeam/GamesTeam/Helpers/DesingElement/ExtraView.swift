//
//  ExtraView.swift
//  GamesTeam
//
//  Created by kam_team on 06.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

class ExtraView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = SettingsApp.cornerRadius
        self.backgroundColor = ColorApp.whiteApp
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.1
        self.layer.masksToBounds = false
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
