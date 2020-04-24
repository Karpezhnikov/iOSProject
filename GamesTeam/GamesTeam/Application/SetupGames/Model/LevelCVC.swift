//
//  LevelCVC.swift
//  GamesTeam
//
//  Created by kam_team on 04.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

class LevelCVC: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var infoLevel: UILabel!
    @IBOutlet weak var backgroundViewLevel: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.name.font = UIFont(name: FontApp.markerWide, size: 21)
        self.infoLevel.font = UIFont(name: FontApp.appleSDMedium, size: 13)
        
        self.backgroundViewLevel.layer.cornerRadius = SettingsApp.cornerRadius
    }
    
}
