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
    

    @IBOutlet weak var stackViewButton: UIStackView!
    @IBOutlet weak var nameDeteilService: UILabel!
    @IBOutlet weak var imageService: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var singUpButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var descriptionService: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup stackViewButton
        //stackViewButton.layer.borderWidth = BorderWidth.borderWidth
        //stackViewButton.layer.borderColor = ColorApp.black.cgColor
        
        masters = StorageManager.getMasterFromTheDataBase(service) // получаем всех мастеров для услуги
        
        nameDeteilService.text = service.nameService // устанавливаем заголовок
        imageService.image = getImageService()
        descriptionService.text = service.serviceDescription
    }
    
    // функция для безопасного добавления фото
    private func getImageService() -> UIImage{
        guard service.image != nil else {
            return UIImage(named: "DSC_0698")!
        }
        let image = UIImage(data: service.image!)
        return image!
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        guard let identifire = segue.identifier, let makeAppr = segue.destination as? MakeAppointmentVC
        else {return}
        if identifire == "makeAppointment"{
            makeAppr.service = service
            makeAppr.arrayMaster = masters
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
