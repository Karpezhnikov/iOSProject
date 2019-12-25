//
//  PersonAccountVC.swift
//  Flamingo
//
//  Created by mac on 23/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import Firebase

class PersonAccountVC: UIViewController {

    var arrayTableViewService = Array<Service>()
    var arrayTableViewServiceEntry = Array<ServiceEntry>()
    
    //@IBOutlet weak var buttonBonusPhoto: UIButton!
    @IBOutlet weak var buttonBonusPhoto: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonExit: UIButton!
    @IBOutlet weak var imagePerson: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberPhoneTF: UITextField!
    //@IBOutlet weak var bonusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        
        let user = UserDefaults.standard.string(forKey: "namePerson")
        if user != nil{ //если выполнен вход в аккаунт то пойвляется кнопка
            //buttonExit.title = "Выйти"
            buttonExit.isEnabled = true
        }else{ // если нет, то кнопка исчезает
            //buttonExit.title = ""
            buttonExit.isEnabled = false
        }
    }
    

    
    @IBAction func exitAccount(_ sender: Any) {
        print("нажата")
        UserDefaults.standard.removeObject(forKey: "namePerson")
        UserDefaults.standard.removeObject(forKey: "numberPerson")
        UserDefaults.standard.removeObject(forKey: "adminPerson")
        UserDefaults.standard.removeObject(forKey: "numberVerif")
        //buttonExit.title = ""
        buttonExit.isEnabled = false
    }
    
    
    @IBAction func actionEdit(_ sender: Any) {
    }
    
    
    @IBAction func actionBonusOrPhoto(_ sender: Any) {
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentControll.selectedSegmentIndex {
        case 0:
            arrayTableViewServiceEntry.removeAll()
            let result = realm.objects(ServiceEntry.self)
            for serviceEntry in result{
                arrayTableViewServiceEntry.append(serviceEntry)
            }
            tableView.reloadData()
            print("Показ записей")
        case 1:
            arrayTableViewService.removeAll()
            let result = realm.objects(Service.self).filter("favorites = \(true)")
            for service in result{
                arrayTableViewService.append(service)
            }
            tableView.reloadData()
            //print("Показ избранных")
        default:
            return
        }
    }
    
}

//MARK: Table View
extension PersonAccountVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControll.selectedSegmentIndex == 0{
            return arrayTableViewServiceEntry.count
        }else{
            return arrayTableViewService.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTVCellSample
        if segmentControll.selectedSegmentIndex == 0{
            // заполняем для таблицы с записями
            cell.nameService.text = arrayTableViewServiceEntry[indexPath.row].serviceName
            let dttm = arrayTableViewServiceEntry[indexPath.row].dttmEntry.components(separatedBy: ",")
            if dttm.count != 3{
                cell.timeService.text = ""
                cell.price.text = ""
            }else{
                cell.timeService.text = "\(dttm[0]), \(dttm[1])"
                cell.price.text = "\(dttm[2])"
            }
            
            // достаем изображение услуги по номеру документа
            let serviceId = arrayTableViewServiceEntry[indexPath.row].serviceIdDocument
            let imageServiceEntry = realm.objects(Service.self).filter("id = '\(serviceId)'")
            let imageBackground = UIImageView()
            imageBackground.image = UIImage(data: imageServiceEntry[0].image!)
            //print("Background")
            imageBackground.contentMode = .scaleAspectFill
            //imageBackground.alpha = 0.5
            cell.backgroundView = imageBackground
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }else{
            //let arrayToDisplay = isFiltering ? filteredService[indexPath.row] : services[indexPath.row]
            cell.nameService.text = arrayTableViewService[indexPath.row].nameService
            cell.price.text = "\(arrayTableViewService[indexPath.row].placeService)"
            cell.timeService.text = arrayTableViewService[indexPath.row].timeService
            let imageBackground = UIImageView()
            imageBackground.image = UIImage(data: arrayTableViewService[indexPath.row].image!)
            //print("Background")
            imageBackground.contentMode = .scaleAspectFill
            //imageBackground.alpha = 0.5
            cell.backgroundView = imageBackground
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    // заполняем таблицу для вывода мастеров
//    private func getArrayRealmClasses(_ arrayMasterFor: Array<Master>){
//
//        for master in arrayMasterFor{
//            arrayMaster.append(master)
//        }
//    }
    
    
}
