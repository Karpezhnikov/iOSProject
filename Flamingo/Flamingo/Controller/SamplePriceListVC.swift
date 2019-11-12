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
    
    var modelController = ModelController()
    private let arrayHashtagSeatch = SeatchHashtag()
    private let searchController = UISearchController(searchResultsController: nil)//nil-для отображения
    
    private var services: Results<Service>! {// тип контейнера, // массив с отобранными записями
        didSet{ // при изменении массива обновляем данные в таблице
            tableView.reloadData()
        }
    }
    
    private var filteredService: Results<Service>!{
        didSet{ // при поиске выводим результат в таблицу
            tableView.reloadData()
        }
    } // массив для поиска (список найденых объектов)
    
    private var seatchBarIsEmpty:Bool{
        guard let text = searchController.searchBar.text else {return false} // если получилось добраться до бара
        return text.isEmpty // смотрим есть ли в поиске что-то
    }
    
    private var isFiltering:Bool{
        return searchController.isActive && !seatchBarIsEmpty // если поисковая сторока активна и не является пустой
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar() // настраиваем кнопку назад
        getDataFromTheDataBase() // запоняем services
        setupSearchBar() // добавляем поиск
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
        if isFiltering{ //  если ищем в поиске
            return filteredService.count // возвращаем кольчество найденых результатов
        }
        return  (services.count == 0) ? 0 : services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTVCellSample
        
        let arrayToDisplay = isFiltering ? filteredService[indexPath.row] : services[indexPath.row]
        cell.nameService.text = arrayToDisplay.nameService
        cell.price.text = "\(arrayToDisplay.placeService)"
        cell.timeService.text = arrayToDisplay.timeService
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // для того, чтобы ячейка не выделялась
    }
}

// MARK: Work Collection View
extension SamplePriceListVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayHashtagSeatch.seatchHashtagDesignation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "hashtagSeatch", for: indexPath) as? CustumCVC{
            itemCell.hashtagLabel.text = "#\(arrayHashtagSeatch.seatchHashtagDesignation[indexPath.row].emojiDesignation)"
            return itemCell
        }
        return UICollectionViewCell()
    }
    
    // для поиска по нажатой ячейки
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.endEditing(true)
        searchController.searchBar.text = arrayHashtagSeatch.seatchHashtagDesignation[indexPath.row].textDesignation
        // ToDo: добавить скрытик клавиатуры при поиске по тегу
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

// MARK: Work with Seatch
extension SamplePriceListVC: UISearchResultsUpdating{
    // Настраиваем searchBar
    private func setupSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false // параметр не позволяет работать с этим view как с основным(отключаем)
        searchController.searchBar.placeholder = "Seatch"// вставляем подсказку
        navigationItem.searchController = searchController // устанавливаем в напигейшн бар
        definesPresentationContext = true // позволяет отпустить строку поиска при переходе на другой экран
    }
    
    // функция для поиска
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSeatchText(searchController.searchBar.text!)
    }

    // поиск из данного массива
    private func filterContentForSeatchText(_ searchText: String){
        // фильтруем массив по имени
        filteredService = services.filter("nameService CONTAINS[c] %@ OR partOfTheBody CONTAINS[c] %@", searchText, searchText)
        //tableView.reloadData()
    }
}
