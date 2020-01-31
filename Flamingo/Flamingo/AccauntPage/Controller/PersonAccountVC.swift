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

    let numberPhone = UserDefaults.standard.string(forKey: "numberPerson")
    var arrayTableViewService = Array<Service>()
    var arrayTableViewServiceEntry = Array<ServiceEntry>()
    var modelPerson = ModelVCPerson()
    
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
    @IBOutlet weak var buttonsRegSV: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if numberPhone != nil{ //если выполнен вход в аккаунт то пойвляется кнопка
            //buttonExit.title = "Выйти"
            print("Есть логин")
            getDataServiceEntry() // вытаскиваем все записи
            nameTextField.text = UserDefaults.standard.string(forKey: "namePerson")
            numberPhoneTF.text = UserDefaults.standard.string(forKey: "numberPerson")
            buttonsRegSV.isHidden = true
            buttonExit.isHidden = false
            buttonEdit.isHidden = false
            buttonBonusPhoto.isHidden = false
        }else{ // если нет, то кнопка исчезает
            print("Нет логин")
            //buttonExit.title = ""
            nameTextField.text = ""
            numberPhoneTF.text = ""
            buttonsRegSV.isHidden = false
            buttonExit.isHidden = true
            buttonEdit.isHidden = true
            buttonBonusPhoto.isHidden = true
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Получилось")
    }
    
    @IBAction func unwindToThisPersonAccountVC(segue: UIStoryboardSegue) {

        print("Переход")
    }
    
    func update1233(){
        print("Получилось")
    }
    
    //MARK: Actions
    // кнопка выхода из аккаунта
    @IBAction func exitAccount(_ sender: Any) {
        print("нажата")
        UserDefaults.standard.removeObject(forKey: "namePerson")
        UserDefaults.standard.removeObject(forKey: "numberPerson")
        UserDefaults.standard.removeObject(forKey: "adminPerson")
        UserDefaults.standard.removeObject(forKey: "numberVerif")
        
        //cleat data account
        nameTextField.text = ""
        numberPhoneTF.text = ""
        arrayTableViewService.removeAll()
        arrayTableViewServiceEntry.removeAll()
        tableView.reloadData()
        buttonBonusPhoto.setTitle("", for: .normal)
        
        //buttonExit.title = ""
        buttonExit.isHidden = true
        buttonsRegSV.isHidden = false
    }
    
    
    @IBAction func actionEdit(_ sender: Any) {
    }
    
    //Action бонусы
    @IBAction func actionBonusOrPhoto(_ sender: Any) {
    }
    
    @IBAction func actionRegistration(_ sender: Any) {
        if let vc = UIStoryboard(name: "Registration", bundle: nil).instantiateInitialViewController() {
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }
    }
    
    //управления segmentControll
    @IBAction func indexChanged(_ sender: Any) {
        guard numberPhone != nil else {
            return
        }
        switch segmentControll.selectedSegmentIndex {
        case 0:
            getDataServiceEntry()
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
    
    private func getDataServiceEntry(){
        arrayTableViewServiceEntry.removeAll()
        let result = realm.objects(ServiceEntry.self)
        for serviceEntry in result{
            arrayTableViewServiceEntry.append(serviceEntry)
        }
        tableView.reloadData()
        //print("Показ записей")
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
//        if segmentControll.selectedSegmentIndex == 0{
//            // заполняем для таблицы с записями
//            cell.nameService.text = arrayTableViewServiceEntry[indexPath.row].serviceName
//            let dttm = arrayTableViewServiceEntry[indexPath.row].dttmEntry.components(separatedBy: ",")
//            if dttm.count != 3{
//                cell.timeService.text = ""
//                cell.price.text = ""
//            }else{
//                cell.timeService.text = "\(dttm[0]), \(dttm[1])"
//                cell.price.text = "\(dttm[2])"
//            }
//
//            // достаем изображение услуги по номеру документа
//            let serviceId = arrayTableViewServiceEntry[indexPath.row].serviceIdDocument
//            let imageServiceEntry = realm.objects(Service.self).filter("id = '\(serviceId)'")
//            if imageServiceEntry.count != 0{
//                let imageBackground = UIImageView()
//                imageBackground.image = UIImage(data: imageServiceEntry[0].image!)
//                //print("Background")
//                imageBackground.contentMode = .scaleAspectFill
//                //imageBackground.alpha = 0.5
//                cell.backgroundView = imageBackground
//                cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            }
//            else {
//                cell.backgroundView?.backgroundColor = ColorApp.black
//            }
//            return cell
//        }else{
//            //let arrayToDisplay = isFiltering ? filteredService[indexPath.row] : services[indexPath.row]
//            cell.nameService.text = arrayTableViewService[indexPath.row].nameService
//            cell.price.text = "\(arrayTableViewService[indexPath.row].placeService)"
//            cell.timeService.text = arrayTableViewService[indexPath.row].timeService
//            let imageBackground = UIImageView()
//            imageBackground.image = UIImage(data: arrayTableViewService[indexPath.row].image!)
//            //print("Background")
//            imageBackground.contentMode = .scaleAspectFill
//            //imageBackground.alpha = 0.5
//            cell.backgroundView = imageBackground
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            return cell
//        }
        return cell
    }
    
    // заполняем таблицу для вывода мастеров
//    private func getArrayRealmClasses(_ arrayMasterFor: Array<Master>){
//
//        for master in arrayMasterFor{
//            arrayMaster.append(master)
//        }
//    }
    
    
}
