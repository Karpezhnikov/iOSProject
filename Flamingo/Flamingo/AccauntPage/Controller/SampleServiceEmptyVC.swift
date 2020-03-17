//
//  SampleServiceEmptyVC.swift
//  Flamingo
//
//  Created by mac on 24/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

//сделать вызод в фаир байс и получить все активные записи

class SampleServiceEmptyVC: UIViewController {
    
    
    var admin = UserDefaults.standard.bool(forKey: "adminFlg")
    var arrayServiceEntry = Array<ServiceEntry>()
    var indexPathPresent = IndexPath()
    var arrayServiceEntrySample = Array<ServiceEntry>()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //firstIn()
        getAllServiceEntry()//получаем данные из Firebase
        if admin{//если это админ убираем segmentedControl
            segmentedControl.isHidden = true
        }
        // устанавливаем цвет текста у segmentedControl
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
//    // изначаль записываем в массив только активные записи
    private func firstIn(){
        arrayServiceEntrySample.removeAll()
        for sample in arrayServiceEntry{
            if sample.dttmEntry > Date(){
                arrayServiceEntrySample.append(sample)
            }
        }
        tableView.reloadData()
    }
    
    //MARK: Actions
    @IBAction func actionActEntry(_ sender: Any) {
        let currentDate = Date()
        //let searchText = ""
        switch  segmentedControl.selectedSegmentIndex{
        case 0:
            firstIn()
        case 1:
            arrayServiceEntrySample.removeAll()
            for sample in arrayServiceEntry{
                if sample.dttmEntry < currentDate{
                    arrayServiceEntrySample.append(sample)
                }
            }
            tableView.reloadData()
        case 2:
            arrayServiceEntrySample.removeAll()
            for sample in arrayServiceEntry{
                arrayServiceEntrySample.append(sample)
            }
            //arrayServiceEntrySample
            tableView.reloadData()
        default:
            arrayServiceEntrySample.removeAll()
            for sample in arrayServiceEntry{
                arrayServiceEntrySample.append(sample)
            }
            tableView.reloadData()
        }
    }
    
    
    @IBAction func actionCancellaration(_ sender: Any) {
        //определяем indexPath ячейки в которой нажата кнопка
        guard let indexPath = tableView.indexPathForRow(at: (sender as AnyObject).convert(CGPoint(), to: tableView)) else {
            return
        } // определяем индекс строки
        indexPathPresent = indexPath
        let alertThing = UIAlertController(title: "Отменить запись?", message: "", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Нет", style: .cancel)
        let cencelEntry = UIAlertAction(title: "Отменить", style: .default) { [weak self](_) in
            FirebaseManager.deleteDocument(self!.arrayServiceEntrySample[indexPath.row].id, "", "service_enrty", "")
            if self!.admin == false{
                StorageManager.deleteObjectRealm(self!.arrayServiceEntrySample[indexPath.row]) //delete data Realm
            }
            self!.arrayServiceEntrySample.remove(at: indexPath.row)
            self!.tableView.reloadData()
        }
        alertThing.addAction(cancel)
        alertThing.addAction(cencelEntry)
        self.present(alertThing, animated: true, completion: nil)
        
    }
    
    @IBAction func actionPresentService(_ sender: Any) {
        //определяем indexPath ячейки в которой нажата кнопка
        guard let indexPath = tableView.indexPathForRow(at: (sender as AnyObject).convert(CGPoint(), to: tableView)) else {
            return
        } // определяем индекс строки
        indexPathPresent = indexPath
    }
    
    @IBAction func actionPresentMaster(_ sender: Any) {
        //определяем indexPath ячейки в которой нажата кнопка
        guard let indexPath = tableView.indexPathForRow(at: (sender as AnyObject).convert(CGPoint(), to: tableView)) else {
            return
        } // определяем индекс строки
        indexPathPresent = indexPath
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToAccauntVC", sender: nil)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier else {return}
        if identifire == "presentMaster"{
            let master = realm.objects(Master.self).filter("id CONTAINS[c] %@", arrayServiceEntrySample[indexPathPresent.row].idMaster)
            guard let destinationVC = segue.destination as? AddNewMasterVC else {return}
            guard master.count != 0 else {return}
            destinationVC.master = master.first!
            destinationVC.viewFlg = true
            
        }
        if identifire == "presentService"{
            let service = realm.objects(Service.self).filter("id CONTAINS[c] %@", arrayServiceEntrySample[indexPathPresent.row].serviceIdDocument)
            guard service.count != 0 else {return}
            guard let detailServiceVC = segue.destination as? DetailServiceVC else{return}
            detailServiceVC.service = service.first!
        }
        
    }

}

//MARK: Table View
extension SampleServiceEmptyVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayServiceEntrySample.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceEnryTVCell
        cell.nameService.text = arrayServiceEntrySample[indexPath.row].serviceName
        cell.labelMaster.text = "Специалист"
        let idMaster = arrayServiceEntrySample[indexPath.row].idMaster
        let master = realm.objects(Master.self).filter("id CONTAINS[c] %@", idMaster)//вытаскиваем мастера
        if master.count != 0{// проверяем что мастер есть
            cell.nameMaster.text = master.first?.name
        }else{
            cell.nameMaster.text = ""
        }
        cell.timeServiceEntry.text = WorkTimeAndDate.dateFromConvert(arrayServiceEntrySample[indexPath.row].dttmEntry, mask: "MMM d, HH:mm")
        // определяем положение сегмента и активируем или дективируем ячейку
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cell.activate()
        case 1:
            cell.diactivate()
        default:
            if arrayServiceEntrySample[indexPath.row].dttmEntry > Date(){
                cell.activate()
            }else{
                cell.diactivate()
            }
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if admin == false{//проверка на админа
            return nil//если нет, то отлючаем действия с удалением
        }
        
        let deleteItem = UIContextualAction(style: .normal, title: nil) {  [weak self] (contextualAction, view, boolValue) in
            // вызываем окно подтверждения удаления
            self!.alertCallPerson(self!.arrayServiceEntrySample[indexPath.row])
        }
        deleteItem.backgroundColor = ColorApp.black
        deleteItem.image = UIImage(systemName: "phone")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem])
        swipeActions.performsFirstActionWithFullSwipe = false

        return swipeActions
    }
    
    
}

//MARK: Admin
extension SampleServiceEmptyVC{
    //позвонить клиенту
    private func alertCallPerson(_ serviceEntryA: ServiceEntry){
        let actionSheet = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        actionSheet.message = "\(serviceEntryA.nameClient)"
        let openTEL = UIAlertAction(title: "тел:\(serviceEntryA.numberPhoneClient)", style: .default) { (_) in
            if let url = URL(string: "тел://\(serviceEntryA.numberPhoneClient)") {
                UIApplication.shared.open(url)
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        actionSheet.addAction(openTEL)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
    
    // берем из firebase все записи, которые больше сегодняшнее даты и записываем в массив 
    private func getAllServiceEntry(){
        let persons = realm.objects(Person.self)
        guard let person = persons.first else {
            return
        }
        arrayServiceEntry.removeAll()
        let fireBaseCollection = FirebaseManager.firebaseBD.collection("service_enrty")
        
        if admin{
            fireBaseCollection.whereField("dttmEntry", isGreaterThan: Date())
                .getDocuments() { [weak self](snapshot, err) in
                    if err != nil {
                        print("Error getting documents: \(err!)")
                        return
                    }else{
                        guard snapshot != nil else {
                            return
                        }
                        for document in snapshot!.documents{
                            let data = document.data()
                            let serviceEntryFirebase = ServiceEntry()
                            guard let timeStump = (data["dttmEntry"] as? Timestamp) else {return}
                            serviceEntryFirebase.dttmEntry = timeStump.dateValue()
                            serviceEntryFirebase.id = document.documentID
                            serviceEntryFirebase.idMaster = data["idMaster"] as? String ?? ""
                            serviceEntryFirebase.nameClient = data["nameClient"] as? String ?? ""
                            serviceEntryFirebase.price = data["price"] as? String ?? ""
                            serviceEntryFirebase.numberPhoneClient = data["serviceEnrty"] as? String ?? ""
                            serviceEntryFirebase.serviceIdDocument = data["serviceIdDocument"] as? String ?? ""
                            serviceEntryFirebase.serviceName = data["serviceName"] as? String ?? ""
                            self!.arrayServiceEntry.append(serviceEntryFirebase)
                            
                        }
                        //сортируем по дате и перезаписываем
                        self!.arrayServiceEntry = self!.arrayServiceEntry.sorted{$0.dttmEntry > $1.dttmEntry}
                        self!.firstIn()
                    }
            }
            
        }else{
            print("No Admin")
            fireBaseCollection.whereField("serviceEnrty", isEqualTo: person.numberPhone)
                .getDocuments() { [weak self](snapshot, err) in
                    if err != nil {
                        print("Error getting documents: \(err!)")
                        return
                    }else{
                        guard snapshot != nil else {
                            return
                        }
                        for document in snapshot!.documents{
                            let data = document.data()
                            let serviceEntryFirebase = ServiceEntry()
                            guard let timeStump = (data["dttmEntry"] as? Timestamp) else {return}
                            serviceEntryFirebase.dttmEntry = timeStump.dateValue()
                            serviceEntryFirebase.id = document.documentID
                            serviceEntryFirebase.idMaster = data["idMaster"] as? String ?? ""
                            serviceEntryFirebase.nameClient = data["nameClient"] as? String ?? ""
                            serviceEntryFirebase.price = data["price"] as? String ?? ""
                            serviceEntryFirebase.numberPhoneClient = data["serviceEnrty"] as? String ?? ""
                            serviceEntryFirebase.serviceIdDocument = data["serviceIdDocument"] as? String ?? ""
                            serviceEntryFirebase.serviceName = data["serviceName"] as? String ?? ""
                            self!.arrayServiceEntry.append(serviceEntryFirebase)
                        }
                        //сортируем по дате и перезаписываем
                        self!.arrayServiceEntry = self!.arrayServiceEntry.sorted{$0.dttmEntry > $1.dttmEntry}
                        self!.firstIn()
                    }
            }
        }
    }
}
