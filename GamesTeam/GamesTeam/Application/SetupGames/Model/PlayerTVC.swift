//
//  PlayerTVC.swift
//  GamesTeam
//
//  Created by kam_team on 06.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

class PlayerTVC: UITableViewCell {

    
    
    @IBOutlet weak var namePlayer: UILabel!
    
    @IBOutlet weak var deletePlayer: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.deletePlayer.setImage(UIImage(systemName: "person.badge.minus.fill"), for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
