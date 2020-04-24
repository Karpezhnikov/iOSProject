//
//  GameListVC.swift
//  GamesTeam
//
//  Created by kam_team on 02.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

class GameListVC: UIViewController {

    let arrayGames = realm.objects(GameRealm.self)
    
    @IBOutlet weak var tableViewGames: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewGames.separatorStyle = .none
    }
    
    
    //MARK: - Actions
    @IBAction func playGameAction(_ sender: Any){
        guard let indexPathTB = tableViewGames.indexPathForRow(at: (sender as AnyObject).convert(CGPoint(), to: tableViewGames)) else {
            return
        }
        let setupGame = UIStoryboard(name: "SetupGames", bundle: nil)
        guard let setupGameVC = setupGame.instantiateViewController(withIdentifier: "SetupGameVC") as? SetupGameVC else{return}
        
        if let firstSett = realm.objects(SettingsGameRealm.self).filter("gameId = \(arrayGames[indexPathTB.row].id)").first{
            setupGameVC.settingsGame = firstSett
        }else{
            return
        }
        setupGameVC.modalPresentationStyle = .fullScreen
        self.present(setupGameVC, animated: true, completion: nil)
    }
}

//MARK: Table View
extension GameListVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableViewGames.dequeueReusableCell(withIdentifier: "CellGame", for: indexPath) as? CellGame else{
            return UITableViewCell()
        }
        let game = arrayGames[indexPath.row]
        cell.nameGame.text = game.name
        if let imageGame = UIImage(data: game.imageData){
            cell.imageGame.image = imageGame
        }
        
        cell.getFavorite(game.favorite)
        cell.setupButtons(game.sale, game.isBuy)
        cell.countPlayers.setupCountPlayers(minPlayers: game.minPlayers, maxPlayers: game.maxPlayers)
        let arrayStar = [cell.fiveStar, cell.forStar, cell.threeStar, cell.twoStar, cell.oneStar]
        getRating(arrayStar as! Array<UIImageView>, game.rating)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewGames.frame.size.height * 0.3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presentGameSTB = UIStoryboard(name: "PresentGame", bundle: nil)
        guard let presentGameVC = presentGameSTB.instantiateViewController(withIdentifier: "PresentGameVC") as? PresentGameVC else{return}
        presentGameVC.gamePresent = arrayGames[indexPath.row]
        presentGameVC.modalPresentationStyle = .fullScreen
        self.present(presentGameVC, animated: true, completion: nil)
    }
}
