//
//  TrueAndActionVC.swift
//  GamesTeam
//
//  Created by kam_team on 11.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit
import RealmSwift

class TrueAndActionVC: UIViewController {

    var arrayNamePlayers = Array<String>() //массив и именами игроков
    //var game = Game() // класс игры
    var settingsGame = SettingsGameRealm()
    //var gameID = Int()
    var arrayQQs = Array<QuestionsAndActions>() // отобранный массив с вопросами
    var arrayActions = Array<QuestionsAndActions>() // отобранный массив с действиями
    var nextQuestionOrAction: QuestionsAndActions? = nil //следующий вопрос или действие
    var playerMove = 0 //номер игрока, который ходит
    var arrayProcessGame = Array<GameProcessTrueAndAction>(){
        didSet{
            self.tableViewGameProcess.reloadData()
            self.tableViewGameProcess.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @IBOutlet weak var namePlayer: UILabel!
    @IBOutlet weak var buttonTrue: UIButton!
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var viewActions: UIView!
    @IBOutlet weak var tableViewGameProcess: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupElements()
    
        self.updateArrayQQS() //заполняем массив с вопросами
        self.updateArrayActions() //заполняем массив с действиями
        self.notificationTrueAndFalseVC()
        // Do any additional setup after loading the view.
    }
    
    ////обновляем вопросы по выбраным пареметрам
    private func updateArrayQQS(){
        guard let levelQue = decoderStringToArray(settingsGame.lavels).first else {return}
        self.arrayQQs = RealmManager.getArrayQue(gameID: settingsGame.gameId,
                                                 isAbult: settingsGame.isAbultGame,
                                                 isAlcohol: settingsGame.isAlcoholGame,
                                                 level: levelQue)
    }
    
    //// обновляем действие по выбранным параметрам
    private func updateArrayActions(){
        guard let levelQue = decoderStringToArray(settingsGame.lavels).first else {return}
        self.arrayActions = RealmManager.getArrayAction(gameID: settingsGame.gameId,
                                                        isAbult: settingsGame.isAbultGame,
                                                        isAlcohol: settingsGame.isAlcoholGame,
                                                        level: levelQue)
    }
    
    private func setupElements(){
        
        self.namePlayer.text = "\(arrayNamePlayers[playerMove]),"
        
        self.viewActions.backgroundColor = ColorApp.bluePale
        self.viewActions.layer.cornerRadius = SettingsApp.cornerRadius
        self.viewActions.layer.shadowColor = UIColor.black.cgColor
        self.viewActions.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.viewActions.layer.shadowRadius = 5.0
        self.viewActions.layer.shadowOpacity = 0.2
        self.viewActions.layer.masksToBounds = false
        
        self.buttonTrue.layer.cornerRadius = SettingsApp.cornerRadius
        self.buttonTrue.backgroundColor = ColorApp.orange
        self.buttonTrue.setTitleColor(ColorApp.whiteApp, for: .normal)
        self.buttonTrue.titleLabel?.font = UIFont(name: FontApp.markerWide, size: 20)
        
        self.buttonAction.layer.cornerRadius = SettingsApp.cornerRadius
        self.buttonAction.backgroundColor = ColorApp.purple
        self.buttonAction.setTitleColor(ColorApp.whiteApp, for: .normal)
        self.buttonAction.titleLabel?.font = UIFont(name: FontApp.markerWide, size: 20)
        
        self.tableViewGameProcess.backgroundColor = .clear
        self.tableViewGameProcess.separatorStyle = .none
    }
    
    //MARK: Actions
    @IBAction func closeCV(_ sender: UIButton){
        let closeAVC = CloseGameAVC()
        closeAVC.addActionsAVC(self)
        self.present(closeAVC, animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func actionTrue(_ sender: Any) {
        if self.arrayQQs.count == 1{ //если в массиве остался последний элемент
            self.updateArrayQQS() // то обновим его
        }else if self.arrayQQs.count == 0{
            self.updateArrayQQS()
            return
        }
        self.nextQuestionOrAction = arrayQQs.remove(at: 0)
        performSegue(withIdentifier: "goActionAndTrue", sender: nil)
    }
    
    
    @IBAction func actionAction(_ sender: Any) {
        if self.arrayActions.count == 1{
            self.updateArrayActions()
        }else if self.arrayActions.count == 0{
            self.updateArrayActions()
            return
        }
        self.nextQuestionOrAction = arrayActions.remove(at: 0)
        performSegue(withIdentifier: "goActionAndTrue", sender: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goActionAndTrue"{
            guard let segueVC = segue.destination as? PresentTrueAndActionVC else {
                return
            }
            segueVC.questionOrAction = self.nextQuestionOrAction
        }else if segue.identifier == "presentProcessGame"{
            guard let segueVC = segue.destination as? PresentTrueAndActionVC else {
                return
            }
            guard let indexPathSel = tableViewGameProcess.indexPathForSelectedRow else {
                return
            }
            segueVC.questionOrAction = arrayProcessGame[indexPathSel.row].process
            segueVC.presentProcessGame = true
        }
    }
}

//MARK: Next player move
extension TrueAndActionVC{
    @objc func nextPlayerMove(){
        ////добавляем игровой ход
        if let processGame = self.nextQuestionOrAction{
            let gameProcess = GameProcessTrueAndAction(bodyGameProcess: arrayNamePlayers[playerMove], process: processGame)
            self.arrayProcessGame.insert(gameProcess, at: 0)
        }
        //устанавливаем следующего игрока
        playerMove += 1
        playerMove = (playerMove > arrayNamePlayers.count-1) ? 0 : playerMove
        namePlayer.text = arrayNamePlayers[playerMove] + ","
        
        
        
    }
}

//MARK: Notification
extension TrueAndActionVC{
    private func notificationTrueAndFalseVC(){
        NotificationCenter.default.addObserver(self, selector: #selector(nextPlayerMove), name: NSNotification.Name(rawValue: "nextPlayerMoveTrueAndActionVC"), object: nil)
    }
}

//MARK: Table View
extension TrueAndActionVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayProcessGame.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CellGameProcess", for: indexPath) as? CellGameProcess{
            let processGameInfo = arrayProcessGame[indexPath.row]
            cell.gameProcess.text = "\(processGameInfo.bodyGameProcess)"
            cell.setBackgroundColor(processGameInfo.process?.qoa ?? QOA.none)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "presentProcessGame", sender: nil)
    }
    
}


//MARK: Get Data Of Realm
extension TrueAndActionVC{
    
}
