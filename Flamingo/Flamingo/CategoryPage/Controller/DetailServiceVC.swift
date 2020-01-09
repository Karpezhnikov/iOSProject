//
//  DetailServiceVC.swift
//  Flamingo
//
//  Created by mac on 16/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class DetailServiceVC: UIViewController {

    var service = Service() // выбраная услуга
    private var masters = [Master]() // для списка всех мастеров
    
    @IBOutlet weak var buttonFavorites: UIButton!{
        didSet{
            if service.favorites{
                buttonFavorites.setImage(UIImage(systemName: "star.fill"), for: .normal)
                buttonFavorites.tintColor = UIColor.yellow
            }
        }
    }
    @IBOutlet weak var imageService: UIImageView!
    @IBOutlet weak var nameService: UILabel!
    @IBOutlet weak var descriptionService: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("1")
        masters = StorageManager.getMasterFromTheDataBase(service) // получаем всех мастеров для услуги
        nameService.text = service.nameService // устанавливаем заголовок
        imageService.image = getImageService()
        descriptionService.text = service.serviceDescription
        
//        UITabBar.appearance().barTintColor = UIColor.clear
//        UITabBar.appearance().backgroundImage = UIImage()
//        
//        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController!.navigationBar.shadowImage = UIImage()
//        self.navigationController!.navigationBar.isTranslucent = true
//        self.navigationController!.view.backgroundColor = UIColor.clear
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
    
    
    @IBAction func favoritesAction(_ sender: Any) {
        
        let updateFavorites = realm.objects(Service.self).filter("id = '\(service.id)'").first
        
        if updateFavorites!.favorites{
            StorageManager.updateFavorites(service.id)
            buttonFavorites.setImage(UIImage(systemName: "star"), for: .normal)
            buttonFavorites.tintColor = ColorApp.black
        }else{
            StorageManager.updateFavorites(service.id)
            buttonFavorites.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonFavorites.tintColor = UIColor.yellow
        }
        //let check = realm.objects(Service.self).filter("id = '\(service.id)'")[0]
        //print(check.favorites)
        //updateFavorites.favorites = true
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

extension DetailServiceVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return masters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMasters", for: indexPath) as! MasterTVCell
        cell.nameMaster.text = masters[indexPath.row].name
        cell.profilMaster.text = masters[indexPath.row].profil
        if let imageData = masters[indexPath.row].image{
            cell.imageMaster.image = UIImage(data: imageData)
        }
        cell.timeAndPrice.text = "\(service.timeService), \(service.placeService)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // для того, чтобы ячейка не выделялась
    }
    
    
}
