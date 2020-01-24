//
//  DescontVC.swift
//  Flamingo
//
//  Created by mac on 19/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase


class DiscontVC: UIViewController {

    let actionSheet = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
    var indexPathRowUpdate = Int() // запоминает индекс строки выбраной к редактированию
    var refreshControl:UIRefreshControl!
    var indexPathRow = IndexPath()
    private var disconts: Results<Discont>!{
        didSet{
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        actionSheet.setupCallAction()
        disconts = realm.objects(Discont.self) // получаем все акции
    }
    
    //MARK: Open Info
    @IBAction func callAction(_ sender: Any) {
        present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier else {return}
        if identifire == "updateDiscontSegue" {
            let destinationVC = segue.destination as! AddNewDiscontVC
            destinationVC.discontUpdate = disconts[indexPathRowUpdate]
            
        }
    }
    
    // ToDo: добавить одновление сразу после изменения или добавления объекта
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .background).async { // в асинхронном режиме записываем данные
            FirebaseManager.getDataDicontsOfFirebase()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        guard segue.identifier == "backToDiscont" else{return}
    }
    
    //MARK: Setup UIRefreshControl
    private func setupRefreshControl(){ // ToDo: сделать активной RefreshControl пока не закончится подгрузка
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.backgroundColor = .black
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        DispatchQueue.global(qos: .background).async { // в асинхронном режиме записываем данные
            FirebaseManager.getDataDicontsOfFirebase()
            DispatchQueue.main.async { [weak self] in
                self!.disconts = realm.objects(Discont.self) // получаем все акции и обновляем TB
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in// через секунду закрываем actionSheet и view
                    self!.refreshControl.endRefreshing()
                }
                
            }
        }
        //refreshControl.colo
        
    }
    
}



// MARK: Work these TableView
extension DiscontVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disconts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellDiscont", for: indexPath) as! CustomTVCellDiscont
        //print("TableView",disconts[indexPath.row].name)
        cell.newDiscont.isHidden = true
        cell.nameDiscont.text = disconts[indexPath.row].name
        cell.descriptionDiscount.text = disconts[indexPath.row].descriptionDiscont
        cell.imageDiscont.image = UIImage(data: disconts[indexPath.row].image!)
        cell.imageDiscont.contentMode = .scaleAspectFill
        cell.info.text = disconts[indexPath.row].descriptionDiscont
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let standartWidth = UIScreen.main.bounds.size.width - 20 // 20 - left and rigth constrains
        if indexPathRow == indexPath{ // если обновляется нужный индекс
            guard let cell = tableView.cellForRow(at: indexPathRow) as? CustomTVCellDiscont
                else{return standartWidth}// получаем ячейку
            let heightCell = cell.frame.height//высота ячейки
            let distanceHeight = cell.info.frame.size.height + cell.buttonAlertInfo.frame.size.height + 10 + 20 + 10//высота на которую нужно увеличить
            if cell.frame.height == standartWidth{//если она не открыта,
                return heightCell + distanceHeight // то открываем
            }else{
                return standartWidth // если открыта, то закрываем
            }
        }
        return standartWidth // делаем высоту равной ширине ячейки
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPathRow = indexPath // записываем номер ячейки на которую нажали
        self.tableView.reloadRows(at: [indexPathRow], with: UITableView.RowAnimation.automatic)// обновляем ее
        self.tableView.scrollToRow(at: indexPathRow, at: .middle, animated: true)//прокручиваем до нужной позиции
        tableView.deselectRow(at: indexPath, animated: true) // для того, чтобы ячейка не выделялась
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // добавляем базовый функционал для управления ячейками ячейки
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteItem = UIContextualAction(style: .normal, title: nil) {  [weak self](contextualAction, view, boolValue) in
            // вызываем окно подтверждения удаления
            let actionSheet = UIAlertController(title: nil, message: "Удалить акцию?", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Удалить", style: .default) { (_) in
                // delete document
                let discont = self!.disconts[indexPath.row]
                //FirebaseManager.deleteDiscont(discont) // удаляем данные из FireBase
                FirebaseManager.deleteDocument(discont.id, discont.imageURL, "disconts", "discont_images")
                StorageManager.deleteObjectRealm(discont) // удаляем из Realm
                self!.disconts = realm.objects(Discont.self) // перезаполняем массив
                
            }
            let cancel = UIAlertAction(title: "Отмена", style: .cancel)
            actionSheet.addAction(cancel)
            actionSheet.addAction(delete)
            self!.present(actionSheet, animated: true)
        }
        deleteItem.backgroundColor = ColorApp.black
        deleteItem.image = UIImage(named: "trash")
        // если нажата кнопка редактирования то переходит на экран добавления записи
        let changeItem = UIContextualAction(style: .normal, title: nil) {  [weak self](contextualAction, view, boolValue) in
            self!.indexPathRowUpdate = indexPath.row // записываем индекс строки которую редактируем
            self!.performSegue(withIdentifier: "updateDiscontSegue", sender: nil)
            
        }
        changeItem.backgroundColor = ColorApp.black
        changeItem.image = UIImage(named: "refresh")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, changeItem])
        swipeActions.performsFirstActionWithFullSwipe = false

        return swipeActions
    }
    
    
}
