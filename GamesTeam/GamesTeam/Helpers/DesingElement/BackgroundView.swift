//
//  BackgroundView.swift
//  GamesTeam
//
//  Created by kam_team on 03.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ColorApp.blackApp.withAlphaComponent(0.4)
        self.layer.cornerRadius = SettingsApp.cornerRadius
        
//        self.layer.shadowRadius = 5.0
//        self.layer.shadowOpacity = 0.1
//        self.layer.shadowOffset = CGSize.zero
        
        self.layer.cornerRadius = SettingsApp.cornerRadius
        self.backgroundColor = ColorApp.whiteApp
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
        
        
    }

}
