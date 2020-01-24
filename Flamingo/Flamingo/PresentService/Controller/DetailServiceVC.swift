//
//  DetailServiceVC.swift
//  Flamingo
//
//  Created by mac on 16/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class DetailServiceVC: UIViewController {

    let actionSheetCall = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
    let actionSheetWA = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
    var service = Service() // выбраная услуга
    private var masters = [Master]() // для списка всех мастеров
    
    @IBOutlet weak var labelMasters: SetupLabel!
    @IBOutlet weak var buttonMakeApp: SetupButton!
    @IBOutlet weak var buttonCall: SetupButton!
    @IBOutlet weak var buttonSendMessage: SetupButton!
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
    @IBOutlet weak var collectionViewMasters: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionSheetCall.setupCallAction()
        actionSheetWA.setupactionSheet()
        setupCollectionView()
        masters = StorageManager.getMasterFromTheDataBase(service) // получаем всех мастеров для услуги
        if masters.count == 0{ //Если нет специалистов не показываем лейбл
            labelMasters.isHidden = true
        }
        
        imageService.image = getImageService()
        imageService.layer.cornerRadius = imageService.frame.size.width*0.01
        
        nameService.text = service.nameService // устанавливаем заголовок
        descriptionService.text = service.serviceDescription
        
        designButton(buttonCall)
        designButton(buttonMakeApp)
        designButton(buttonFavorites)
        designButton(buttonSendMessage)
    }

    private func setupCollectionView(){
        
        //collectionViewMasters
        collectionViewMasters.backgroundColor = .clear
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.collectionViewMasters?.collectionViewLayout = layout
        
        //collectionViewDesign
        //collectionViewDesign.backgroundColor = .clear
        //self.collectionViewDesign?.collectionViewLayout = layout
    }
    
    private func designButton(_ button: UIButton){
        //button.layer.borderWidth = BorderWidth.borderWidth
        button.layer.borderColor = ColorApp.white.cgColor
        button.layer.cornerRadius = button.layer.frame.size.width/2
        button.backgroundColor = ColorApp.white.withAlphaComponent(0.1)
        
        
    }
    
    // функция для безопасного добавления фото
    private func getImageService() -> UIImage{
        guard service.image != nil else {
            return UIImage(named: "DSC_0698")!
        }
        let image = UIImage(data: service.image!)
        return image!
    }
    
    //MARK: Actions
    @IBAction func openWhatsApp(_ sender: Any) {
        present(actionSheetWA, animated: true)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callAction(_ sender: Any) {
        present(actionSheetCall, animated: true, completion: nil)
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
        guard let identifire = segue.identifier
        else {return}
        if identifire == "makeAppointment"{
            guard let makeAppr = segue.destination as? MakeAppointmentVC else {return}
            makeAppr.service = service
            makeAppr.arrayMaster = masters
        }
        if identifire == "presentMaster"{
            if let indexPath = collectionViewMasters.indexPathsForSelectedItems?.first{
                guard let destinationVC = segue.destination as? AddNewMasterVC else {return}
                destinationVC.master = masters[indexPath.row]
                destinationVC.viewFlg = true
            }
        }
    }
    
}

//MARK: Collection View
extension DetailServiceVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return masters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as! MasterCVC
        item.name.text = masters[indexPath.row].name
        item.profil.text = masters[indexPath.row].profil
        if let imageData = masters[indexPath.row].image{
            if let image = UIImage(data: imageData){
                item.image.image = image
                item.image.imageCornerRadiusPlusBorder()
            }
        }
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let widthItem = collectionView.frame.size.width*0.4
        let heightItem = collectionView.frame.size.height - 2
        return CGSize(width: heightItem, height: heightItem)
        
    }
    
}
