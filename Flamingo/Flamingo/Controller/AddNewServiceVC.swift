//
//  AddNewServiceVC.swift
//  Flamingo
//
//  Created by mac on 05/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import Firebase

class AddNewServiceVC: UIViewController {

    let picker = UIPickerView()
    let datePicker = UIDatePicker()
    let actionSheet = UIAlertController(title: nil, message: "", preferredStyle: .alert)
    var arrayPickerData = Array<String>()
    var serviceNew = Service()
    
    
    @IBOutlet weak var imageService: UIImageView!
    @IBOutlet weak var nameService: UITextField!
    @IBOutlet weak var timeService: UITextField!
    @IBOutlet weak var priceService: UITextField!
    @IBOutlet weak var descriptionService: UITextView!
    @IBOutlet weak var nameCategoryOfService: UITextField!
    @IBOutlet weak var cosmetologiService: UITextField!
    @IBOutlet weak var partOfTheBody: UITextField!
    @IBOutlet weak var maleMan: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var masterTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTextFieldEmpty() // вызываем тригеры на заполнение полей
        setupPicker()
        setupDatePicker()
        setupViewElements()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //animate.animateAlpha(element: nameDiscont, toAlpha: 0.5, animateRunTime: 5.5)//шаг 2 - исчезает название
        
    }
    
    // MARK: Get Image Action
    @IBAction func addImage(_ sender: Any) {
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
    
    // MARK: Save Action
    @IBAction func saveAction(_ sender: Any) {
        saveImageToFirebaseStorage()
        collectService()
        
        actionSheet.message = "Подождите..." // создаем уведомление о процессе загрузки
        present(actionSheet, animated: true)
        
        print("URL is Empty.", "Saving is in progress!")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in // ждем 5 секунд, чтобы успел придти imageURL
            guard !self!.serviceNew.imageURL.isEmpty else { // проверяем на то, что imageURL заполнен
                self!.saveButton.isUserInteractionEnabled = true
                self!.saveButton.alpha = 1
                self!.actionSheet.message = "Не удалось сохранить. Попробуйте еще раз."
                let cancel = UIAlertAction(title: "ОК", style: .cancel)
                self!.actionSheet.addAction(cancel)
                return
            }
            print("imageURL -> ", self!.serviceNew.imageURL)
            
            FirebaseManager.saveServiceToFirebase(self!.serviceNew)
            
            
            //StorageManager.saveObjectDiscount(self!.discont)
            self!.actionSheet.message = "Сохранено"
            // ToDo: Обновление
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // через секунду закрываем actionSheet и view
                self!.actionSheet.dismiss(animated: true)
                self!.dismiss(animated: true, completion: nil)
                //self!.performSegue(withIdentifier: "backToDiscont", sender: nil)
            }
            
            
        }
    }
    
    private func collectService(){
        serviceNew.nameService = nameService.text ?? ""
        serviceNew.placeService = priceService.text ?? ""
        serviceNew.timeService = timeService.text ?? ""
        serviceNew.serviceDescription = descriptionService.text ?? ""
        serviceNew.nameCategoryService = nameCategoryOfService.text ?? ""
        serviceNew.comsmetology = cosmetologiService.text ?? ""
        serviceNew.partOfTheBody = partOfTheBody.text ?? ""
        serviceNew.maleMan = maleMan.text ?? ""
    }

}

// MARK: Check isEmpty TextField
extension AddNewServiceVC{
    private func checkTextFieldEmpty(){
        nameService.addTarget(self, action: #selector(checkNameService), for: .editingDidEnd)
        timeService.addTarget(self, action: #selector(checkTimeService), for: .editingDidEnd)
        priceService.addTarget(self, action: #selector(checkPriceService), for: .editingDidEnd)
        nameCategoryOfService.addTarget(self, action: #selector(checkNameCategoryOfService), for: .editingDidEnd)
        cosmetologiService.addTarget(self, action: #selector(checkCosmetologiService), for: .editingDidEnd)
        partOfTheBody.addTarget(self, action: #selector(checkPartOfTheBody), for: .editingDidEnd)
        maleMan.addTarget(self, action: #selector(checkMaleMan), for: .editingDidEnd)
    }
    
    @objc func checkNameService(){
        if nameService.text!.isEmpty{
        }else{
            nameService.layer.borderWidth = 0
            //nameService.backgroundColor = ColorApp.greenComplete
        }
    }
    
    @objc func checkTimeService(){
        if timeService.text!.isEmpty{
        }else{
            timeService.layer.borderWidth = 0
            //timeService.backgroundColor = ColorApp.greenComplete
        }
    }
    
    @objc func checkPriceService(){
        if priceService.text!.isEmpty{
        }else{
            priceService.layer.borderWidth = 0
            //priceService.backgroundColor = ColorApp.greenComplete
        }
    }
    
    @objc func checkNameCategoryOfService(){
        if nameCategoryOfService.text!.isEmpty{
        }else{
            nameCategoryOfService.layer.borderWidth = 0
            //nameCategoryOfService.backgroundColor = ColorApp.greenComplete
        }
    }
    
    @objc func checkCosmetologiService(){
        if cosmetologiService.text!.isEmpty{
        }else{
            cosmetologiService.layer.borderWidth = 0
            //cosmetologiService.backgroundColor = ColorApp.greenComplete
        }
    }
    
    @objc func checkPartOfTheBody(){
        if partOfTheBody.text!.isEmpty{
        }else{
            partOfTheBody.layer.borderWidth = 0
            //partOfTheBody.backgroundColor = ColorApp.greenComplete
        }
    }
    
    @objc func checkMaleMan(){
        if maleMan.text!.isEmpty{
        }else{
            maleMan.layer.borderWidth = 0
            //maleMan.backgroundColor = ColorApp.greenComplete
        }
    }
}

// MARK: Work with image
extension AddNewServiceVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        imageService.image = info[.editedImage] as? UIImage // присваиваем отредактирование изображение
        imageService.contentMode = .scaleAspectFit // распределяем изображение по формату
        imageService.clipsToBounds = true // обрезаем границы
        dismiss(animated: true)
    }
    
}

// MARK: Save Image To Storage
extension AddNewServiceVC{
    // save image and get URL image path
    private func saveImageToFirebaseStorage(){
        let imageName = (nameService.text == "") ? "imageService": nameService.text // создаем имя для картинки по названию акции
        let storage = Storage.storage().reference().child("service_images") // получаем доступ к папке
        let ref = storage.child(imageName!) // кладем изображения по пути
        
        if let uploadData = imageService.image?.jpegData(compressionQuality: 0.2){ // переводим изображение в NSData
            ref.putData(uploadData, metadata: nil) { [weak self] (metadata, error) in // добавляем изображение
                if error != nil{
                    print(error!)
                    return
                }
                ref.downloadURL { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    // ToDo: придумать как перенести функцию в FireBaseManager
                    self!.serviceNew.imageURL = url!.absoluteString // получаем url изображения
                    
                }
            }
        }
    }
}


// MARK: Work UIPicker
extension AddNewServiceVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    private func setupPicker(){ // определяет поле на которое нажали и обозначаем делегатов
        picker.delegate = self
        picker.dataSource = self
        // в зависимости от нажатого поля заполняем массив для picker
        maleMan.addTarget(self, action: #selector(editingMaleMan(_:)), for: .editingDidBegin)
        partOfTheBody.addTarget(self, action: #selector(editingPartOfTheBody(_:)), for: .editingDidBegin)
        nameCategoryOfService.addTarget(self, action: #selector(editingNameCategoryOfService(_:)), for: .editingDidBegin)
        cosmetologiService.addTarget(self, action: #selector(editingCosmetologiService(_:)), for: .editingDidBegin)
    }
    
    @objc func editingCosmetologiService(_ textField: UITextField) {
        arrayPickerData.removeAll() // очищаем массив
        cosmetologiService.inputView = picker // для появления поля по нажатию на nameMaster
        //getMastersName() // быбираем всез мастеров и записываем в массив arrayPickerData
        arrayPickerData.append("1 Косметология")
        arrayPickerData.append("2 Косметология")
        arrayPickerData.append("3 Косметология")
        arrayPickerData.append("")
        picker.reloadAllComponents() // обновляем список компонентов
    }
    
    @objc func editingNameCategoryOfService(_ textField: UITextField) {
        arrayPickerData.removeAll() // очищаем массив
        nameCategoryOfService.inputView = picker // для появления поля по нажатию на nameMaster
        //getMastersName() // быбираем всез мастеров и записываем в массив arrayPickerData
        arrayPickerData.append("Массаж лица")
        arrayPickerData.append("Пиллинг лица")
        arrayPickerData.append("Чистка лица")
        arrayPickerData.append("")
        picker.reloadAllComponents() // обновляем список компонентов
    }
    
    @objc func editingMaleMan(_ textField: UITextField) {
        arrayPickerData.removeAll() // очищаем массив
        maleMan.inputView = picker // для появления поля по нажатию на nameMaster
        //getMastersName() // быбираем всез мастеров и записываем в массив arrayPickerData
        arrayPickerData.append("Для мужчин")
        arrayPickerData.append("Для женчин")
        arrayPickerData.append("Для всех")
        arrayPickerData.append("")
        picker.reloadAllComponents() // обновляем список компонентов
    }
    
    @objc func editingPartOfTheBody (_ textField: UITextField) {
        arrayPickerData.removeAll() // очищаем массив
        partOfTheBody.inputView = picker // для появления поля по нажатию на nameService
        arrayPickerData.append("Волосы")
        arrayPickerData.append("Голова")
        arrayPickerData.append("Лицо")
        arrayPickerData.append("Тело")
        arrayPickerData.append("Руки")
        arrayPickerData.append("Ноги")
        arrayPickerData.append("")
        picker.reloadAllComponents() // обновляем список компонентов
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if maleMan.isEditing{
            maleMan.text = arrayPickerData[row]
        }
        if partOfTheBody.isEditing{
            partOfTheBody.text = arrayPickerData[row]
        }
        if nameCategoryOfService.isEditing{
            nameCategoryOfService.text = arrayPickerData[row]
        }
        if cosmetologiService.isEditing{
            cosmetologiService.text = arrayPickerData[row]
        }
        return arrayPickerData[row]
    }
    
    
}

// MARK: Setup Elements
extension AddNewServiceVC{
    private func setupViewElements(){
        // setup UIDatePicker
        setupDatePicker()
        
        // setup UIImageView
        self.imageService.contentMode = .scaleToFill
        self.imageService.layer.cornerRadius = 40
        
        // setup UITextView
        self.descriptionService.layer.cornerRadius = nameService.layer.cornerRadius
        self.descriptionService.layer.borderWidth = nameService.layer.borderWidth
        self.descriptionService.layer.borderColor = nameService.layer.borderColor
        self.descriptionService.font = Font.fontRegular
        
        
        self.saveButton.layer.cornerRadius = 10
        self.saveButton.layer.borderWidth = BorderWidth.borderWidth
        self.saveButton.layer.borderColor = ColorApp.greenComplete.cgColor
        self.saveButton.backgroundColor = ColorApp.clear
        self.saveButton.setTitleColor(ColorApp.greenComplete, for: .normal)
    }
}

// MARK: Setup DatePicker
extension AddNewServiceVC{
    private func setupDatePicker(){
        
        // ToDo: сделать так чтобы DatePicker при первом нажатии не выаодил текущее время
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone)) //для закрытия UIPicker по клику на экран
        self.view.addGestureRecognizer(tapGesture)
        
        timeService.inputView = datePicker //для того, чтобы пикер появлялся по нажатию на поле
        datePicker.datePickerMode = .time //запись даты и времени
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged) // тригер срабатывает при изменении
    }
    
    @objc func dateChanged(){ // для записи в dateStart и dateEnd
        getDateFromPicker(datePicker.date, timeService)
    }
    
    @objc func tapGestureDone(){ // для закрытия пикера по тапу на любую часть экрана
        view.endEditing(true)
    }
    
    private func getDateFromPicker(_ date: Date,_ element: UITextField){
        let formatter = DateFormatter() //  создаем форматер
        formatter.dateFormat = "HH:mm" // создаем формат даты и времени
        let localeID = Locale.preferredLanguages.first // определяем локацию для времени
        formatter.locale = Locale(identifier: localeID!)
        element.text = formatter.string(from: date) // записываем дату в dateStart
    }
}

// MARK: Table view
extension AddNewServiceVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = masterTableView.dequeueReusableCell(withIdentifier: "masterCell", for: indexPath)
        
        return cell
    }
    
    
}
