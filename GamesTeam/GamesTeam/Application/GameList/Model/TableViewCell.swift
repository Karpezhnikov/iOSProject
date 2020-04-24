//
//  TableViewCell.swift
//  GamesTeam
//
//  Created by kam_team on 02.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

class CellGame: UITableViewCell {
    
    
    @IBOutlet weak var oneStar: UIImageView!
    @IBOutlet weak var twoStar: UIImageView!
    @IBOutlet weak var threeStar: UIImageView!
    @IBOutlet weak var forStar: UIImageView!
    @IBOutlet weak var fiveStar: UIImageView!
    
    
    @IBOutlet weak var viewCountPlayers: UIView!
    @IBOutlet weak var imagePlayers: UIImageView!
    @IBOutlet weak var countPlayers: UILabel!
    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var nameGame: UILabel!
    @IBOutlet weak var playGame: UIButton!
    @IBOutlet weak var buyGame: UIButton!
    @IBOutlet weak var favoriteGame: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.imageGame.layer.cornerRadius = SettingsApp.cornerRadius
        
        self.nameGame.font = UIFont(name: FontApp.markerWide, size: 25)
        
        self.playGame.setTitle("Играть", for: .normal)
        self.playGame.setupButtonOval()
        self.buyGame.setupButtonOval()
        
        self.imagePlayers.image = UIImage(systemName: "person.fill")
        self.imagePlayers.tintColor = ColorApp.whiteApp
        self.viewCountPlayers.setupOvalView()
        self.viewCountPlayers.backgroundColor = ColorApp.purpleApp?.withAlphaComponent(0.5)
        self.countPlayers.textColor = ColorApp.whiteApp
        
    }
    
    //устанавливает цену(если есть)
    func setupButtons(_ sale: String, _ isBuy: Bool){
        self.playGame.setupButtonPlay(sale, isBuy)
        self.buyGame.setupButtonBuy(sale, isBuy)
    }
    
    //отмечаем фаворита
    func getFavorite(_ favor: Bool){
        if favor{
            let imageB = UIImage(systemName: "flame.fill")
            self.favoriteGame.setImage(imageB, for: .normal)
        }else{
            let imageB = UIImage(systemName: "flame")
            self.favoriteGame.setImage(imageB, for: .normal)
        }
    }
    
}
