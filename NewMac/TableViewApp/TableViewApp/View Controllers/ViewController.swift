//
//  ViewController.swift
//  TableViewApp
//
//  Created by Алексей Карпежников on 15/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)//nil-для отображения результата в том же view
    private var places: Results<Place>!
    private var ascendingSorting = true // для сортировки по возрастанию/убыванию (поумолчанию - возрастание)
    private var filteredPlaces: Results<Place>!
    private var seatchBarIsEmpty:Bool{
        guard let text = searchController.searchBar.text else {return false} // если получилось добраться до бара
        return text.isEmpty // смотрим есть ли в поиске что-то
    }
    private var isFiltering:Bool{
        return searchController.isActive && !seatchBarIsEmpty // если поисковая сторока активна и не является пустой
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reverstSortingButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self) //заполняем массив из базы
        tableView.tableFooterView = UIView() // заменяем нижнию часть на просто VIEW(чтобы исбавится от линий)
        
        // Setup serchController
        searchController.searchResultsUpdater = self // получатель инфо будет этот view
        searchController.obscuresBackgroundDuringPresentation = false // параметр не позволяет работать с этим view как с основным(отключаем)
        searchController.searchBar.placeholder = "Seatch"// вставляем подсказку
        navigationItem.searchController = searchController // устанавливаем в напигейшн бар
        definesPresentationContext = true // позволяет отпустить строку поиска при переходе на другой экран
    }
    

    // MARK: Table view data sourse
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{ // если производится поиск
            return filteredPlaces.count // то возвращаем количество найденых строк
        }
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        
        switch Int(place.rating) {
        case 5:
            cell.rating.text = "\(place.rating)"
            cell.rating.textColor = .green
        case 4:
            cell.rating.text = "\(place.rating)"
            cell.rating.textColor = .green
            cell.rating.alpha = 0.5
        default:
            cell.rating.text = "\(place.rating)"
            cell.rating.textColor = .gray
        }
        
        return cell
    }
    
    
    // MARK: Table View delegate
    // ф-я которая определяет свайп по экрану
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let place = places[indexPath.row]
        // кнопка для удаления записи
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { _, _,_   in
            StorageManager.deleteObject(place)//удаляем из базы
            tableView.deleteRows(at: [indexPath], with: .automatic)// удаляем строку
        }
        
        return .init(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // для того, чтобы ячейка не выделялась
    }
    
    // MARK: Navigation
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        guard let newPlaceVC = segue.source as? NewPlaceViewController else {return}
        newPlaceVC.savePlace() // запускаем метод для заполнения массива значений
        tableView.reloadData() // обновляем данные
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDeteil"{ // определяем нужный сигвей
            guard let indexPath = tableView.indexPathForSelectedRow else {return} // определяем индекс строки
            // создаем экземпляр класса по нужному индексу
            let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
            let newPlaceVC = segue.destination as! NewPlaceViewController // создаем связть с другим вью
            newPlaceVC.currentPlace = place
        }
    }
    
    // MARK: Sorting Table
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    
    
    @IBAction func reverstSorting(_ sender: Any) {
        ascendingSorting.toggle() // меняет значени на противоположное
        if ascendingSorting{
            reverstSortingButton.image = #imageLiteral(resourceName: "AZ")
        }else{
            reverstSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    
    private func sorting(){
        if segmentedControl.selectedSegmentIndex == 0{
            // сортируем по дате (ascending - в какую сторону(true-убывание, false-возрастание))
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        }else{
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
    
}

extension ViewController: UISearchResultsUpdating{
    // MARK: Seatch
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSeatchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSeatchText(_ searchText: String){
        // фильтруем массив по имени
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }
    
}
