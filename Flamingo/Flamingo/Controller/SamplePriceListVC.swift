//
//  SamplePriceListVC.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 25/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift

class SamplePriceListVC: UIViewController{
    
    private var services: Results<Service>! // тип контейнера, который возвращает все объекты(массив)
    var arrayServises = Array<Service>(){
        didSet{ // при изменении массива обновляем данные в таблице
            tableView.reloadData()
        }
    } // массив с отобранными записями
    var humanMale = ""
    var modelController = ModelController()
    
    let arrayHashtagSeatch = ["все","ноги","руки","тело","голова","волосы","голова","тело", "пресс","сиськи","они","мываываывчысывацуа"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = modelController.partOfBody
        setupNavigationBar() // настраиваем кнопку назад 
        
        services = realm.objects(Service.self) // берем все объекты типа Service
        deleteDuplicates(services: services) // вытаскиваем список для отображения всех service
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let detailServiceVC = segue.destination as? DetailServiceVC
        else {return}
        if identifire == "segueDetail"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return} // определяем индекс строки
            detailServiceVC.service = arrayServises[indexPath.row]
        }
    }
    
}

// MARK: Work Table View
extension SamplePriceListVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  (arrayServises.count == 0) ? 0 : arrayServises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTVCell
        
        cell.nameService.text = arrayServises[indexPath.row].nameService
        cell.price.text = "\(arrayServises[indexPath.row].placeService)"
        cell.timeService.text = arrayServises[indexPath.row].timeService
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // для того, чтобы ячейка не выделялась
    }
}

// MARK: Work Collection View
extension SamplePriceListVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayHashtagSeatch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "hashtagSeatch", for: indexPath) as? CustumCVC{
            itemCell.hashtagLabel.text = "#\(arrayHashtagSeatch[indexPath.row])"
//            itemCell.layer.borderWidth = 0.5
            
            
            return itemCell
        }
        return UICollectionViewCell()
    }
    
    // для получения нажатой ячейки
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        modelController.seatchTeg = arrayHashtagSeatch[indexPath.row]
        if indexPath.row == 0{ // если нажат hashtag "все"
            arrayServises.removeAll() // очищаем массив
            deleteDuplicates(services: services) // вытаскиваем список для отображения всех service
            return // выходим
        }else{
            arrayServises.removeAll() // очищаем массив
            deleteDuplicates(services: services) // вытаскиваем список для отображения всех service
            arrayServises = getServicesHashtag(hashtag: modelController.seatchTeg, inServices: arrayServises)
        }
    }
        
    
}

// MARK: Get array Service param
extension SamplePriceListVC{
    // заполняет список услуг для вывода на экран
    private func deleteDuplicates(services: Results<Service>){
        switch (modelController.partOfBody == "AllPartOfBody") { // если перешли c tap bar
        case true:
            //self.title = "Список услуг"
            self.navigationItem.title = modelController.nameServiceCategory // вставляем заголовок
            
            for service in services{ // выводим весь список услуг
                if service.nameCategoryService == modelController.nameServiceCategory{ // если услуга соответствует выбраной категории
                    arrayServises.append(service)
                    arrayServises = Array(Set<Service>(arrayServises))
                }
            }
        case false:
            for service in services{
                if service.partOfTheBody == modelController.partOfBody
                    && (service.maleMan == modelController.maleMan
                        || service.maleMan == "unisex")
                { // отбор по части тела
                    arrayServises.append(service) // получаем все service
                }
            }
            arrayServises = Array(Set<Service>(arrayServises)) // убераем дубли
        }
    }
    
    private func getServicesHashtag(hashtag: String, inServices: Array<Service>)->Array<Service>{
        
        var outServices = Array<Service>()
        
        for service in inServices{
            if service.comsmetology.uppercased() == hashtag.uppercased() ||
                service.cosmetics.uppercased() == hashtag.uppercased() ||
                service.maleMan.uppercased() == hashtag.uppercased() ||
                service.nameCategoryService.uppercased() == hashtag.uppercased() ||
                service.nameService.uppercased() == hashtag.uppercased() ||
                service.partOfTheBody.uppercased() == hashtag.uppercased() ||
                String(service.placeService) == hashtag.uppercased(){
                outServices.append(service)
            }
        }
        
        return outServices
    }
}

// MARK: SetupNavigationBar
extension SamplePriceListVC{
    
    private func setupNavigationBar(){
        // настраиваем кнопку назад
        if let topItem = navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            
            //topItem.backBarButtonItem?.image = UIImage(named: "leftBarButton")
            let imgBackArrow = UIImage(named: "leftBarButton")

            navigationController?.navigationBar.backIndicatorImage = imgBackArrow
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        }
        
    }
}
