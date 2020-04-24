//
//  PresentGameVC.swift
//  GamesTeam
//
//  Created by kam_team on 03.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

class PresentGameVC: UIViewController {
    
    var gamePresent = GameRealm()

    @IBOutlet weak var oneStar: UIImageView!
    @IBOutlet weak var twoStar: UIImageView!
    @IBOutlet weak var threeStar: UIImageView!
    @IBOutlet weak var forStar: UIImageView!
    @IBOutlet weak var fiveStar: UIImageView!
    @IBOutlet weak var viewFrontImage: UIView!
    
    @IBOutlet weak var rulesGame: UILabel!
    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var countPlayers: UILabel!
    @IBOutlet weak var nameGame: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var infoGame: UILabel!
    @IBOutlet weak var rulesGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        self.viewFrontImage.layer.cornerRadius = SettingsApp.cornerRadius
        // Do any additional setup after loading the view.
    }
    
    private func setupVC(){
        self.imageGame.layer.cornerRadius = SettingsApp.cornerRadius
        self.nameGame.text = gamePresent.name
        self.buyButton.setupButtonBuy(gamePresent.sale, gamePresent.isBuy)
        self.playButton.setupButtonPlay(gamePresent.sale, gamePresent.isBuy)
        let arrayStar = [fiveStar, forStar, threeStar, twoStar, oneStar]
        getRating(arrayStar as! Array<UIImageView>, gamePresent.rating)
        self.countPlayers.setupCountPlayers(minPlayers: gamePresent.minPlayers, maxPlayers: gamePresent.maxPlayers)
        
        
        self.countPlayers.font = UIFont(name: FontApp.appleSDBold, size: 15)
        self.countPlayers.textColor = ColorApp.blackApp
        self.infoGame.font = UIFont(name: FontApp.appleSDBold, size: 15)
        self.infoGame.textColor = ColorApp.blackApp
        self.rulesGame.font = UIFont(name: FontApp.appleSDBold, size: 15)
        self.rulesGame.textColor = ColorApp.blackApp
        self.nameGame.font = UIFont(name: FontApp.markerWide, size: 25)
        self.nameGame.textColor = ColorApp.whiteApp
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentRules"{
            guard let presentRulesVC = segue.destination as? PresentRulesVC else {
                return
            }
            presentRulesVC.arrayRules = decoderRulesGame(gamePresent.rulesGame)
        }
    }
    
    
    // MARK: - Actions
    @IBAction func closeCV(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playGameAction(_ sender: UIButton){
        let setupGame = UIStoryboard(name: "SetupGames", bundle: nil)
        guard let setupGameVC = setupGame.instantiateViewController(withIdentifier: "SetupGameVC") as? SetupGameVC else{return}
        if let firstSett = realm.objects(SettingsGameRealm.self).filter("gameId = \(gamePresent.id)").first{
            setupGameVC.settingsGame = firstSett
        }else{
            return
        }
        setupGameVC.modalPresentationStyle = .fullScreen
        self.present(setupGameVC, animated: true, completion: nil)
    }
    
    @IBAction func rulesGameAction(_ sender: UIButton){
        if gamePresent.sale.isEmpty{
            performSegue(withIdentifier: "presentRules", sender: nil)
            return
        }else{
            if gamePresent.isBuy{
                performSegue(withIdentifier: "presentRules", sender: nil)
            }else{
                let alert = getAlert("Туда нельзя", "Чтобы прочитать правила, необходимо преобрести игру", "ОК")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
