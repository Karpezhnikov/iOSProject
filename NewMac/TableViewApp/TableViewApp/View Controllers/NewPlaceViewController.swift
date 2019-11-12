//
//  NewPlaceViewController.swift
//  TableViewApp
//
//  Created by Алексей Карпежников on 15/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    var imageIsChanged = false // для определения добавлениия фото
    var currentPlace: Place!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // заменяем нижнию часть на просто VIEW(чтобы исбавится от линий)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        saveButton.isEnabled = false
        // для проверки заполнения текстового поля
        placeName.addTarget(self, action: #selector(textFieldChenged), for: .editingChanged)
        
        setupEditScreen()
    }
    
    // MARK: Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // условие для скрытия клавиатуры по нажатию на любое место экрана
        if indexPath.row == 0{
            
            let cameraIcon = #imageLiteral(resourceName: "camera") // создаем значек для камеры
            let photoIcon = #imageLiteral(resourceName: "photo") // создаем значек для альбома
            
            // создаем окно выбора для добавления фото
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            // создаем дейстие для включения камеры
            let camera = UIAlertAction(title:  "Камера",
                                       style: .default) { (_) in
                                        self.chooseImagePicker(sourse: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image") // вставляем значек камеры
            //camera.setValue(CATextLayerAlignmentMode.right, forKey: "tetleTextAligment") // ровняем по левому краю
            
            // создаем дейстие для выбора фото из библиотеки
            let photo = UIAlertAction(title:  "Фото",
                                       style: .default) { (_) in
                                        self.chooseImagePicker(sourse: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")  // вставляем значек альбома
            //photo.setValue(CATextLayerAlignmentMode.right, forKey: "tetleTextAligment")  // ровняем по левому краю
            
            // создаем дейстие для отмены добавления фото
            let cancel = UIAlertAction(title:  "Отменить", style: .cancel)
            // добавляем все созданые действия
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            // выводим меню выбора
            present(actionSheet,animated: true)
            
        }else{ // кроме 0-й ячейки(она используется для добавления фото)
            view.endEditing(true)
        }
    }
    
    func savePlace(){
    
        // если изображение не добавлено, то ставим изодражение по дефолту
        let image = imageIsChanged ? placeImage.image : #imageLiteral(resourceName: "imagePlaceholder")
        
        //записываем данные после нажатия на Save
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: image?.pngData(),
                             rating: Double(ratingControl.rating))
        // определяем нужно добавить данные или обновить
        if currentPlace != nil{
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        }else{
            StorageManager.saveObject(newPlace)
        }
        
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let mapVC = segue.destination as? MapViewController else {return}
        
        mapVC.incomeSegueIdentifier = identifire
        mapVC.mapViewControllerDelegate = self
        
        if identifire == "showPlace"{
            mapVC.place.name = placeName.text!
            mapVC.place.location = placeLocation.text
            mapVC.place.type = placeType.text
            mapVC.place.imageData = placeImage.image?.pngData()
        }
        
    }
    
    // MARK: Setup Edit View
    // ф-я для исправления записи
    private func setupEditScreen(){
        if currentPlace != nil{
            
            setupNavigationBar()
            imageIsChanged = true // при редактировании отмечаем, что фото есть
            
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else {return}
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill // для нормального отображения image
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            ratingControl.rating = Int(currentPlace.rating)
        }
    }
    
    // ф-я для редактирования окна при переходе в режим изменения записи
    private func setupNavigationBar(){
        if let topItem = navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    // при нажатии на кнопку cancel будет закрыт view
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}


// MARK: Text field delegate
extension NewPlaceViewController: UITextFieldDelegate{
    
    // скрываем клавиатуру по кнопке DONE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // проверяем заполнение поля name
    @objc private func textFieldChenged(){
        if placeName.text?.isEmpty == false{
            saveButton.isEnabled = true
        }else{
            saveButton.isEnabled = false
        }
    }
    
}

// MARK: Work with image
extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func chooseImagePicker(sourse: UIImagePickerController.SourceType){
        
        // если источник выбора изображения будет доступен
        if UIImagePickerController.isSourceTypeAvailable(sourse){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true // позволит пользователю редакторовать выбранные изображения
            imagePicker.sourceType = sourse // указываем на источник изображения
            present(imagePicker, animated: true)
        }
    }
    
    // для добавления фото на нам VIEW
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage // берем значение по ключу и приставиваем ему UIImage
        placeImage.contentMode = .scaleAspectFill // позволяем масштабировать изображение по содержимому UIImage
        placeImage.clipsToBounds = true // обрезаем по кантуру UIImage
        imageIsChanged = true // метод вызывается только после добавления фото 
        dismiss(animated: true) // закрываем UIImagePickerController
    }
    
}

extension NewPlaceViewController: MapViewControllerDelegate{
    // в поле address уже содержуься данные
    func getAddress(_ address: String?) {
        placeLocation.text = address
    }
    
    
    
}
