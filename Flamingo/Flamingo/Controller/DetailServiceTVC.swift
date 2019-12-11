//
//  DetailServiceTVC.swift
//  Flamingo
//
//  Created by mac on 14/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class DetailServiceTVC: UITableViewController {

    var service = Service() // выбраная услуга
    private var masters = [Master]() // для списка всех мастеров
    

    @IBOutlet weak var nameDeteilService: UILabel!
    @IBOutlet weak var imageService: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var singUpButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        masters = StorageManager.getMasterFromTheDataBase(service) // получаем всех мастеров для услуги
        nameDeteilService.text = service.nameService // устанавливаем заголовок
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // количесво секций
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true) // для того, чтобы ячейка не выделялась
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let editOnService = segue.destination as? EditOnServiceViewController
        else {return}
        if identifire == "edit"{
            editOnService.service = service
            //editOnService.masters = masters
        }
    }
}

// MARK: - Collection View data source
extension DetailServiceTVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return masters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "masterItem", for: indexPath) as? CustumCVCDeteil{
            itemCell.nameMaster.text = masters[indexPath.row].name
            itemCell.profilMaster.text = masters[indexPath.row].profil
            itemCell.timeAndPriceMaster.text = "\(service.timeService), \(service.placeService)"
            itemCell.imageMaster.image = UIImage(data: masters[indexPath.row].image!)
            
            return itemCell
        }
        return UICollectionViewCell()
    }
}
