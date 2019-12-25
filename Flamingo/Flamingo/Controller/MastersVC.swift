//
//  MastersVC.swift
//  Flamingo
//
//  Created by mac on 09/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift

class MastersVC: UIViewController {
    
    var refreshControl:UIRefreshControl!
    var indexPathRowUpdate = Int() // запоминает индекс строки выбраной к редактированию
    var arrayMaster = Array<Master>(){//массив мастеров для записи в таблицу мастеров
        didSet{
            masterTableView.reloadData()
        }
    }
    
    private var masters: Results<Master>!{
        didSet{
            masterTableView.reloadData()
        }
    }
    
    @IBOutlet weak var masterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        masters = realm.objects(Master.self) // получаем все акции
        // Do any additional setup after loading the view.
    }

}

// MARK: Table view
extension MastersVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return masters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = masterTableView.dequeueReusableCell(withIdentifier: "masterCell", for: indexPath) as! CustomTVCellMaster
        cell.nameMaster.text = masters[indexPath.row].name
        cell.profilMaster.text = masters[indexPath.row].profil
        if let data = masters[indexPath.row].image{
            cell.imageMaster.image = UIImage(data: data)
        } else {
            print("Не удалось отобразить мастера")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        masterTableView.deselectRow(at: indexPath, animated: true) // для того, чтобы ячейка не выделялась
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteItem = UIContextualAction(style: .normal, title: nil) {  [weak self] (contextualAction, view, boolValue) in
            let actionSheet = UIAlertController(title: nil, message: "Удалить специалиста?", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Удалить", style: .default) { (_) in
                // delete document
                let master = self!.masters[indexPath.row]
                FirebaseManager.deleteDocument(master.id, master.imageURL, "masters", "master_images")
                StorageManager.deleteObjectRealm(master) // удаляем из Realm
                self!.masters = realm.objects(Master.self) // перезаполняем массив 
                
            }
            let cancel = UIAlertAction(title: "Отмена", style: .cancel)
            actionSheet.addAction(cancel)
            actionSheet.addAction(delete)
            self!.present(actionSheet, animated: true)
        }
        deleteItem.backgroundColor = ColorApp.black
        deleteItem.image = UIImage(named: "trash")
        
        let changeItem = UIContextualAction(style: .normal, title: nil) {  [weak self](contextualAction, view, boolValue) in
            self!.indexPathRowUpdate = indexPath.row // записываем индекс строки которую редактируем
            self!.performSegue(withIdentifier: "updateMasterSegue", sender: nil)
            
        }
        changeItem.backgroundColor = ColorApp.black
        changeItem.image = UIImage(named: "refresh")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, changeItem])
        swipeActions.performsFirstActionWithFullSwipe = true
        
        return swipeActions
    }
    
    
}

extension MastersVC{
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier else {return}
        
        if identifire == "updateMasterSegue" {
            let destinationVC = segue.destination as! AddNewMasterVC
            destinationVC.masterUpdate = masters[indexPathRowUpdate]
            
        }
        if identifire == "presentMaster"{
            let destinationVC = segue.destination as! AddNewMasterVC
            destinationVC.master = masters[indexPathRowUpdate]
        }
    }
}

extension MastersVC{
    //MARK: Setup UIRefreshControl
    private func setupRefreshControl(){ // ToDo: сделать активной RefreshControl пока не закончится подгрузка
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.backgroundColor = .black
        masterTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        DispatchQueue.global(qos: .background).async { // в асинхронном режиме записываем данные
            FirebaseManager.getDataMastersOfFirebase()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self!.masters = realm.objects(Master.self) // получаем все акции и обновляем TB
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in// через секунду закрываем actionSheet и view
                    self!.refreshControl.endRefreshing()
                }
                
            }
        }
        //refreshControl.colo
        
    }
}
