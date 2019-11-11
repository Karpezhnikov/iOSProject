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
    
    private var services: Results<Service>! {// тип контейнера, который возвращает все объекты(массив)
        didSet{ // при изменении массива обновляем данные в таблице
            tableView.reloadData()
        }
    } // массив с отобранными записями
//    var arrayServises = Array<Service>(){
//        didSet{ // при изменении массива обновляем данные в таблице
//            tableView.reloadData()
//        }
//    } // массив с отобранными записями
    var humanMale = ""
    var modelController = ModelController()
    private let searchController = UISearchController(searchResultsController: nil)//nil-для отображения
    private var filteredService: Results<Service>! // массив для поиска (список найденых объектов)
    private var seatchBarIsEmpty:Bool{
        guard let text = searchController.searchBar.text else {return false} // если получилось добраться до бара
        return text.isEmpty // смотрим есть ли в поиске что-то
    }
    private var isFiltering:Bool{
        return searchController.isActive && !seatchBarIsEmpty // если поисковая сторока активна и не является пустой
    }
    
    let arrayHashtagSeatch = ["все","ноги","руки","тело","голова","волосы","голова","тело", "пресс","сиськи","они","мываываывчысывацуа"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar() // настраиваем кнопку назад
        getDataFromTheDataBase() // запоняем services
        searchController.obscuresBackgroundDuringPresentation = false // параметр не позволяет работать с этим view как с основным(отключаем)
        searchController.searchBar.placeholder = "Seatch"// вставляем подсказку
        navigationItem.searchController = searchController // устанавливаем в напигейшн бар
        definesPresentationContext = true // позволяет отпустить строку поиска при переходе на другой экран
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let detailServiceVC = segue.destination as? DetailServiceVC
        else {return}
        if identifire == "segueDetail"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return} // определяем индекс строки
            detailServiceVC.service = services[indexPath.row]
            //detailServiceVC.service = arrayServises[indexPath.row]
        }
    }
    
}

// MARK: Work Table View
extension SamplePriceListVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  (services.count == 0) ? 0 : services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTVCell
        
        //let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
        cell.nameService.text = services[indexPath.row].nameService
        cell.price.text = "\(services[indexPath.row].placeService)"
        cell.timeService.text = services[indexPath.row].timeService
        
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
            return itemCell
        }
        return UICollectionViewCell()
    }
    
    // для получения нажатой ячейки
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        modelController.seatchTeg = arrayHashtagSeatch[indexPath.row]
        if indexPath.row == 0{ // если нажат hashtag "все"
            print("SDSDSDSDSD")
            getDataFromTheDataBase() // возвразаем обратно все данные
        }else{
            // TODO: сделать функцию которая будет искать по тегу
//            arrayServises.removeAll() // очищаем массив
//            deleteDuplicates(services: services) // вытаскиваем список для отображения всех service
//            arrayServises = getServicesHashtag(hashtag: modelController.seatchTeg, inServices: arrayServises)
        }
    }
        
    
}

// MARK: Get Data From The DataBase
extension SamplePriceListVC{
    
    // функция для выборки данный из БД
    private func getDataFromTheDataBase(){
        if modelController.partOfBody.isEmpty || modelController.maleMan.isEmpty{ // если перешли сразу к всему списку
            self.navigationItem.title = modelController.nameServiceCategory
            services = realm.objects(Service.self).filter("nameCategoryService = '\(modelController.nameServiceCategory)'") // берем все объекты типа Service
        }else{ // берем объекты по условию
            self.navigationItem.title = modelController.partOfBody
            services = realm.objects(Service.self).filter("partOfTheBody = '\(modelController.partOfBody)' AND maleMan = '\(modelController.maleMan)'")
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
//extension SamplePriceListVC: UISearchResultsUpdating{
//    // MARK: Seatch
//    func updateSearchResults(for searchController: UISearchController) {
//        filterContentForSeatchText(searchController.searchBar.text!)
//    }
//
//    private func filterContentForSeatchText(_ searchText: String){
//        // фильтруем массив по имени
//        filteredService = services.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
//        deleteDuplicates(services: filteredService)
//        //tableView.reloadData()
//    }
//
//}
