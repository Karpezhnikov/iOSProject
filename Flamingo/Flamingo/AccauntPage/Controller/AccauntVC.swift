//
//  AccauntVC.swift
//  Flamingo
//
//  Created by mac on 23/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift

class AccauntVC: UIViewController {

    let arrayServiceEntry = realm.objects(ServiceEntry.self)
    let arrayServiceFavorites = realm.objects(Service.self).filter("favorites = \(true)")
    let persons = realm.objects(Person.self)
    
    @IBOutlet weak var buttonAddPhoto: UIButton!
    @IBOutlet weak var numberPerson: UILabel!
    @IBOutlet weak var namePerson: UILabel!
    
    @IBOutlet weak var bonusPerson: UILabel!
    
    @IBOutlet weak var activeAppointments: UILabel!
    @IBOutlet weak var allAppointsments: UILabel!
    @IBOutlet weak var favoritesService: UILabel!
    
    @IBOutlet weak var logInUIView: CustomUIView!
    @IBOutlet weak var allEntryView: CustomUIView!
    @IBOutlet weak var favoriteView: CustomUIView!
    @IBOutlet weak var bonusView: CustomUIView!
    @IBOutlet weak var activeEntryView: CustomUIView!
    @IBOutlet weak var profilDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillInTheData()
        setupViewElements()
    }
    
    //presentFavorites
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let samplePriceList = segue.destination as? SamplePriceListVC else {return}
        if identifire == "presentFavorites"{
            samplePriceList.modelSamplePriceListVC.presentFavorites = true
            samplePriceList.modelSamplePriceListVC.titleController = "Избранное"
        }
    }
    
    //MARK: Action
    @IBAction func unwindToAccauntVC(_ unwindSegue: UIStoryboardSegue) {
        fillInTheData()
        setupViewElements()
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        getImage()
    }
    
    
    private func fillInTheData(){
        //проверяем если ли аккаунт
        if persons.count > 0{
            guard let person = persons.first else{return}
            namePerson.text = person.name
            numberPerson.text = person.numberPhone
            logInUIView.isHidden = true
        }else{
            logInUIView.isHidden = false
            namePerson.text = ""
            numberPerson.text = ""
        }
        
        //посмотреть систему бонусов
        bonusPerson.text = "0"
        activeAppointments.text = "\(countActiveEntry())"
        allAppointsments.text = "\(arrayServiceEntry.count)"
        favoritesService.text = "\(arrayServiceFavorites.count)"
        
        //imagePerson.imageCornerRadiusPlusBorder()
    }


    private func countActiveEntry()->Int{
        var countActiveEntry = 0
        for sample in arrayServiceEntry{
            if sample.dttmEntry > Date(){
                countActiveEntry += 1
            }
        }
        return countActiveEntry
    }
    
    private func setupViewElements(){
        guard let person = persons.first else {
            self.allEntryView.isHidden = true
            self.favoriteView.isHidden = true
            self.bonusView.isHidden = true
            self.activeEntryView.isHidden = true
            self.profilDataView.isHidden = true
            self.logInUIView.isHidden = false
            return
        }
        
        self.allEntryView.isHidden = false
        self.favoriteView.isHidden = false
        self.bonusView.isHidden = false
        self.activeEntryView.isHidden = false
        self.profilDataView.isHidden = false
        self.logInUIView.isHidden = true
        
        if person.image != nil{
            let imageImage = UIImage(data: person.image!)
            buttonAddPhoto.setImage(imageImage, for: .normal)
            buttonAddPhoto.imageView?.layer.cornerRadius = buttonAddPhoto.frame.size.width/2
        }
        
        buttonAddPhoto.layoutIfNeeded()
        buttonAddPhoto.backgroundColor = ColorApp.clear
        buttonAddPhoto.layer.cornerRadius = buttonAddPhoto.frame.size.width/2
        buttonAddPhoto.layer.borderWidth = BorderWidth.borderWidth
        buttonAddPhoto.layer.borderColor = ColorApp.white.cgColor
        
        namePerson.font = UIFont(name: "Helvetica Neue", size: CGFloat(17))
        numberPerson.font = UIFont(name: "Helvetica Neue", size: CGFloat(20))
    }
    
}

// MARK: Work with image picker
extension AccauntVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    private func getImage(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet) // создаем встлывающее окно
        let camera = UIAlertAction(title: "Камера", style: .default) { (_) in
            self.chooseImagePicker(source: .camera)
        }
        let photo = UIAlertAction(title: "Альбом", style: .default) { (_) in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){ // если данный источник доступен
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true // для редактирования изображения
            imagePicker.sourceType = source // определяем откуда будет взято изображение
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePhoto = UIImageView(image: info[.editedImage] as? UIImage)
        imagePhoto.contentMode = .scaleAspectFill // распределяем изображение по формату
        imagePhoto.clipsToBounds = true // обрезаем границы
        buttonAddPhoto.setImage(imagePhoto.image, for: .normal)
        if let person = persons.first{
            let personNew = Person(name: person.name,
                                   numberPhone: person.numberPhone,
                                   admin: person.admin,
                                   numberVerif: person.numberVerif,
                                   image: imagePhoto.image!)
            StorageManager.deleteObjectRealm(person)
            StorageManager.saveObjectRealm(personNew)
            
        }
        dismiss(animated: true)
    }
}
