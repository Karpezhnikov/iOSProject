//
//  SetupGameVC.swift
//  GamesTeam
//
//  Created by kam_team on 04.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

class SetupGameVC: UIViewController {

    //var game = GameRealm()
    var settingsGame = SettingsGameRealm()
    var arrayLevels = Array<Levels>()
    var arrayPlayersName = Array<String>(){
        didSet{
            if arrayPlayersName.count > 0{
                viewPlayers.shadowIsOnView(UIColor.brown, shadowOpacity: 0.4)
            }else{
                viewPlayers.shadowIsOnView(UIColor.black, shadowOpacity: 0.1)
            }
        }
    }
    
    @IBOutlet weak var collectionViewLevels: UICollectionView!
    @IBOutlet weak var titleViewGame: UILabel!
    
    @IBOutlet weak var namePlayerTF: UITextField!
    @IBOutlet weak var addPlayer: UIButton!
    @IBOutlet weak var tableViewPlayers: UITableView!
    @IBOutlet weak var viewPlayers: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var abultGameLabel: UILabel!
    @IBOutlet weak var abultGameView: UIView!
    @IBOutlet weak var alchoholGameLabel: UILabel!
    @IBOutlet weak var alchoholGameView: UIView!
    @IBOutlet weak var goToPlayButton: UIButton!
    
    @IBOutlet weak var abultGameSwitch: UISwitch!
    @IBOutlet weak var alchoholGameSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupTableView()
        self.setupKeyboard()
        self.notificationSetupGameVC()
        
        ////получаем список уровней
        self.arrayLevels = decoderStringToArray(self.settingsGame.lavels)
        
        self.addPlayer.setImage(UIImage(systemName: "person.badge.plus.fill"), for: .normal)
        
        self.namePlayerTF.autocapitalizationType = .words // слова с заглавной буквы
        self.namePlayerTF.inputAccessoryView = self.namePlayerTF.addDoneButtonOnKeyboard() //переписать эту х-ню
        self.namePlayerTF.placeholder = "Введите имя"
    
        self.titleViewGame.font = UIFont(name: FontApp.markerWide, size: 25)
        self.titleViewGame.text = "Настройки"
        
        self.alchoholGameLabel.font = UIFont(name: FontApp.markerWide, size: 15)
        self.abultGameLabel.font = UIFont(name: FontApp.markerWide, size: 15)
        
        self.goToPlayButton.setupButtonPlay("", true)
        self.goToPlayButton.titleLabel?.font = UIFont(name: FontApp.markerWide, size: 25)
        // Do any additional setup after loading the view.
        
        ////возвращаем настройки прошлой игры
        self.alchoholGameSwitch.isOn = settingsGame.isAlcoholGame
        self.abultGameSwitch.isOn = settingsGame.isAbultGame
        
        
        
        arrayPlayersName.append("Алексей")
        arrayPlayersName.append("Иван")
        arrayPlayersName.append("Елена")
        arrayPlayersName.append("Маша")
        tableViewPlayers.heightConstaint?.constant = tableViewPlayers.rowHeight * CGFloat(arrayPlayersName.count)
    }
    
    //ToDo: gjlevfnm как проскролить
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.scrollCollectionViewLevels(settingsGame.nextLevel)
    }
    
    private func scrollCollectionViewLevels(_ nextLevel: String){
        guard !nextLevel.isEmpty else{return}
        for row in 0...arrayLevels.count - 1{
            if arrayLevels[row].nameLevel == nextLevel{
                self.collectionViewLevels.scrollToItem(at: IndexPath(row: row, section: 0), at: .right, animated: true)
                break
            }
        }
    }
    
    //MARK: Actions
    @IBAction func closeCV(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addPlayerAction(_ sender: Any) {
        guard namePlayerTF.text != "", let namePlayer = namePlayerTF.text else{
            namePlayerTF.placeholder = "Введите имя, чтобы добавить игрока"
            return
        }
        self.arrayPlayersName.append(namePlayer)
        self.namePlayerTF.text = ""
        self.updateTableViewHeight(CGFloat(tableViewPlayers.rowHeight))
        self.tableViewPlayers.reloadData()
    }
    
    @IBAction func deletePleyer(_ sender: Any) {
        guard let indexPathDelete = tableViewPlayers.indexPathForRow(at: (sender as AnyObject).convert(CGPoint(), to: tableViewPlayers)) else {
            return
        }
        self.arrayPlayersName.remove(at: indexPathDelete.row)
        self.updateTableViewHeight(-CGFloat(tableViewPlayers.rowHeight))
        self.tableViewPlayers.reloadData()
    }
    
    //обновляем высоту таблицы
    private func updateTableViewHeight(_ heightTB: CGFloat){
        if (tableViewPlayers.heightConstaint != nil){
            tableViewPlayers.heightConstaint?.constant += heightTB
        }
    }
    
    @IBAction func abultGameAction(_ sender: UISwitch) {
        RealmManager.updateIsAbultGame(self.settingsGame, sender.isOn)
        if sender.isOn{
            self.abultGameView.shadowIsOnView(ColorApp.redApp, shadowOpacity: 0.3)
        }else{
            self.abultGameView.shadowIsOnView(ColorApp.blackApp, shadowOpacity: 0.1)
        }
    }
    
    @IBAction func alcoholGameAction(_ sender: UISwitch) {
        RealmManager.updateIsAlcoholGame(self.settingsGame, sender.isOn)
        if sender.isOn{
            self.alchoholGameView.shadowIsOnView(ColorApp.greenApp, shadowOpacity: 0.3)
        }else{
            self.alchoholGameView.shadowIsOnView(ColorApp.blackApp, shadowOpacity: 0.1)
        }
    }
    
    @IBAction func goToPlayAction(_ sender: Any) {
        guard arrayPlayersName.count > 1 else {
            AnimateUI.animateShadow(element: self.viewPlayers, toShadowOpacity: 0.6, animateRunTime: 1)
            return
        }
        RealmManager.updateNextLevel(self.settingsGame, getLevelGame()) //обновляем выбранный уровень
        var presentVC = UIViewController()
        
        switch self.settingsGame.gameId { //создаем UIViewController
        case 1:
            let playingGameSTB = UIStoryboard(name: "TrueAndActionSTR", bundle: nil)
            guard let trueAndActionVC = playingGameSTB.instantiateViewController(withIdentifier: "TrueAndActionVC") as? TrueAndActionVC else{return}
            trueAndActionVC.arrayNamePlayers = arrayPlayersName
            trueAndActionVC.settingsGame = settingsGame
            presentVC = trueAndActionVC
        default:
            return
        }
        
        presentVC.modalPresentationStyle = .fullScreen
        presentVC.modalTransitionStyle = .flipHorizontal
        self.present(presentVC, animated: true, completion: nil)
    }
    
    private func getLevelGame()->String{
        let indexRow = collectionViewLevels.contentOffset.x/view.bounds.size.width
        if indexRow == 0{
            return Levels.Easy.nameLevel
        }else if indexRow > 1{
            return Levels.Middle.nameLevel
        }else{
            return Levels.Hard.nameLevel
        }
    }
}

//MARK: - Collection View
extension SetupGameVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    private func setupCollectionView(){
        let layoutCVC = ZoomAndSnapFlowLayout()
        let minimumLineSpacing = collectionViewLevels.frame.width * 0.07
        let sizeItem = CGSize(width: collectionViewLevels.frame.width * 0.7, height: collectionViewLevels.frame.height * 0.9)
        let activeDistance = collectionViewLevels.frame.width * 0.4
        layoutCVC.setupFlowLayout(minimumLineSpacing: minimumLineSpacing, sizeItem: sizeItem, scrollDirection: .horizontal, activeDistance: activeDistance, zoomFactor: nil)
        self.collectionViewLevels.collectionViewLayout = layoutCVC
        self.collectionViewLevels.showsVerticalScrollIndicator = false
        self.collectionViewLevels.showsHorizontalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayLevels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionViewLevels.dequeueReusableCell(withReuseIdentifier: "LevelCell", for: indexPath) as? LevelCVC{
            let levelCell = self.arrayLevels[indexPath.row]
            cell.name.text = levelCell.nameLevel
            cell.infoLevel.text = levelCell.infoLevel
            cell.backgroundViewLevel.backgroundColor = levelCell.colorLevel
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: - Table View
extension SetupGameVC: UITableViewDelegate, UITableViewDataSource{
    
    private func setupTableView(){
        self.tableViewPlayers.heightConstaint?.constant = 0
        self.tableViewPlayers.separatorStyle = .none
        self.tableViewPlayers.layer.cornerRadius = SettingsApp.cornerRadius
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPlayersName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableViewPlayers.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as? PlayerTVC{
            cell.namePlayer.text = arrayPlayersName[indexPath.row]
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}

//MARK:  - Setup Keyboard
extension SetupGameVC{
    private func setupKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc func kbDidShow( notification: Notification ){
        guard let userInfo = notification.userInfo else {
            return
        }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
    }
    @objc func kbDidHide( notification: Notification ){
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
}

//MARK: Notification
extension SetupGameVC{
    
    @objc func closeVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func notificationSetupGameVC(){
        NotificationCenter.default.addObserver(self, selector: #selector(closeVC), name: NSNotification.Name(rawValue: "CloseSetupGameVC"), object: nil)
    }
}
