//
//  AddNewServiceVC.swift
//  Flamingo
//
//  Created by mac on 05/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import Firebase

//          Done: Создать отдельную форму для добавления мастеров
//          Done: Добавить запись в ФБ мастеров и синхронизировать их с услугой
//          Done: Добавить нормальное сохранения, без использования таймаутов
//          Done: Сделать так, чтобы в UIPickerView данные подгружались по выборке из FireBase


//          Done: разделить добавление мастеров и добавление услуги
//                  сначала создавать мастеров, потом услугу
//          Done: таблица не перезагружается

class AddNewServiceVC: UIViewController {

    let firebaseBD = Firestore.firestore()
    
    let picker = UIPickerView()
    //let datePicker = UIDatePicker()
    let actionSheet = UIAlertController(title: nil, message: "", preferredStyle: .alert)
    let results = realm.objects(Master.self)
    let dataTimePicker = [["0","1","2","3"],["00","05","10","15","20","25","30","35","40","45","50","60"]]
    var hourTimeService = ""
    var serviceUpdate = Service()
    var deleteOrChange = false // флаг для таблицы, для определения действий со строками
    var arrayMasterAdded = Array<Master>()//массив добавленных мастеров мастеров
    var arrayMasterAll = Array<Master>()
    var arrayPickerData = Array<String>(){
        didSet{
            picker.reloadAllComponents() // обновляем список компонентов
        }
    }
    var serviceNew = Service()
    var arrayMaster = Array<Master>(){//массив всех мастеров
        didSet{
            masterTableView.reloadData()
        }
    }
    
    
    // Service param
    @IBOutlet weak var imageService: UIImageView!
    @IBOutlet weak var nameService: UITextField!
    @IBOutlet weak var timeService: UITextField!
    @IBOutlet weak var priceService: UITextField!
    @IBOutlet weak var descriptionService: UITextView!
    @IBOutlet weak var nameCategoryOfService: UITextField!
    @IBOutlet weak var cosmetologiService: UITextField!
    @IBOutlet weak var partOfTheBody: UITextField!
    @IBOutlet weak var maleMan: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var masterTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTextFieldEmpty() // вызываем тригеры на заполнение полей
        editingMode()// определяем режим редактирования иди создание
        setupPicker()
        //setupDatePicker()
        setupViewElements()
        for result in results{
            arrayMasterAll.append(result)
        }
        //getArrayMaster(arrayMasterAll) // обновляем массив для таблицы// изначально заполняем массив со всеми мастерами
        
    }
    
    func generateTime(){
        let hours = dataTimePicker[0]
        let minutes = dataTimePicker[1]
        for hour in hours{
            for mitute in minutes{
                arrayPickerData.append("\(hour):\(mitute)")
            }
        }
        //print(arrayPickerData)
    }
    
    func getDataFirebase(_ getParams: String){
        firebaseBD.collection("param_app").getDocuments() { (querySnapshot, err) in // get disconts
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }else{
                // добавляем новые документы
                for document in querySnapshot!.documents {
                    print(document["\(getParams)"]! as! Array<String> )
                    
                    if let arrayParam = document["\(getParams)"] as? Array<String>{
                        self.arrayPickerData = arrayParam
                        //print(self.arrayPickerData)
                    }
                }
                
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //animate.animateAlpha(element: nameDiscont, toAlpha: 0.5, animateRunTime: 5.5)//шаг 2 - исчезает название
        
    }
    
    // MARK: Action: Get photo Service
    @IBAction func addImage(_ sender: Any) {
        getImage()
        
    }
    
    
    // MARK: Action: Save Service of Firebase
    @IBAction func saveAction(_ sender: Any) {

        saveImageToFirebaseStorage()
        collectService()
        
        actionSheet.message = "Подождите..." // создаем уведомление о процессе загрузки
        present(actionSheet, animated: true)
    }
    
    //MARK: Fill the Service
    // для записи значений из полей
    private func collectService(){
        serviceNew.nameService = nameService.text ?? ""
        serviceNew.placeService = priceService.text ?? ""
        serviceNew.timeService = timeService.text ?? ""
        serviceNew.serviceDescription = descriptionService.text ?? ""
        serviceNew.nameCategoryService = nameCategoryOfService.text ?? ""
        serviceNew.comsmetology = cosmetologiService.text ?? ""
        serviceNew.partOfTheBody = partOfTheBody.text ?? ""
        serviceNew.maleMan = maleMan.text ?? ""
        serviceNew.idsMasters = getMasterIds()
    }
    
    // получаем id всех добавлений мастеров в одно строку через запятую
    private func getMasterIds() -> String{
        var masterIds = ""
        for master in arrayMasterAdded{
            masterIds += ",\(master.id)"
        }
        //masterIds.remove(at: masterIds.startIndex) // удаляем первый символ из строки (",")
        return masterIds
    }
    
    // MARK: Action: Segmented Controll
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 1: // все мастера
            deleteOrChange = false // при выведении всех мастеров, можно только добавлять мастера
            getArrayMaster(arrayMasterAll)
        case 0: // добавленные мастера
            deleteOrChange = true // после добавления можно только удалять мастера
//            if !serviceUpdate.id.isEmpty{// условие заполнения массива доб-х мастеров в режиме изменения
//
//            }
            getArrayMaster(arrayMasterAdded)
            
        default:
            break
        }
    }
    
    // заполняем таблицу для вывода мастеров
    private func getArrayMaster(_ arrayMasterFor: Array<Master>){
        arrayMaster.removeAll() // очищаем массив перед заполнением
        for master in arrayMasterFor{
            arrayMaster.append(master)
        }
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
            nameService.layer.borderWidth = 1
        }else{
            nameService.layer.borderWidth = 0
            //nameService.backgroundColor = ColorApp.greenComplete
        }
    }
    
    @objc func checkTimeService(){
        if timeService.text!.isEmpty{
            timeService.layer.borderWidth = 1
        }else{
            timeService.layer.borderWidth = 0
            //timeService.backgroundColor = ColorApp.greenComplete
        }
    }
    
    @objc func checkPriceService(){
        if priceService.text!.isEmpty{
            priceService.layer.borderWidth = 1
        }else{
            priceService.layer.borderWidth = 0
            //priceService.backgroundColor = ColorApp.greenComplete
        }
    }
    
    @objc func checkNameCategoryOfService(){
        if nameCategoryOfService.text!.isEmpty{
            nameCategoryOfService.layer.borderWidth = 1
        }else{
            nameCategoryOfService.layer.borderWidth = 0
            //nameCategoryOfService.backgroundColor = ColorApp.greenComplete
        }
    }
    
    @objc func checkCosmetologiService(){
        if cosmetologiService.text!.isEmpty{
            cosmetologiService.layer.borderWidth = 1
        }else{
            cosmetologiService.layer.borderWidth = 0
            //cosmetologiService.backgroundColor = ColorApp.greenComplete
        }
    }
    
    @objc func checkPartOfTheBody(){
        if partOfTheBody.text!.isEmpty{
            partOfTheBody.layer.borderWidth = 1
        }else{
            partOfTheBody.layer.borderWidth = 0
            //partOfTheBody.backgroundColor = ColorApp.greenComplete
        }
    }
    
    @objc func checkMaleMan(){
        if maleMan.text!.isEmpty{
            maleMan.layer.borderWidth = 1
        }else{
            maleMan.layer.borderWidth = 0
            //maleMan.backgroundColor = ColorApp.greenComplete
        }
    }
}

// MARK: Work with image picker
extension AddNewServiceVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        imageService.image = info[.editedImage] as? UIImage // присваиваем отредактирование изображение
        imageService.contentMode = .scaleAspectFill // распределяем изображение по формату
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
                    guard self!.serviceNew.imageURL != "" else{
                        self!.saveButton.isUserInteractionEnabled = true
                        self!.saveButton.alpha = 1
                        self!.actionSheet.message = "Не удалось сохранить. Попробуйте еще раз."
                        let cancel = UIAlertAction(title: "ОК", style: .cancel)
                        self!.actionSheet.addAction(cancel)
                        return
                    } // проверяем на пустуб строку в ответе
                    if !self!.serviceUpdate.id.isEmpty{//если режим редактирования
                        print("Обновление")
                        FirebaseManager.saveServiceToFirebase(self!.serviceNew)
                        FirebaseManager.deleteDocument(self!.serviceUpdate.id, self!.serviceUpdate.imageURL, "services", "service_images")
                    }else{
                        FirebaseManager.saveServiceToFirebase(self!.serviceNew)
                    }
                    
                    self!.actionSheet.message = "Сохранено"
                    // ToDo: Обновление
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // через секунду закрываем actionSheet и view
                        self!.actionSheet.dismiss(animated: true)
                        self!.dismiss(animated: true, completion: nil)
                        //self!.performSegue(withIdentifier: "backToDiscont", sender: nil)
                    }
                }
            }
        }
    }
}


// MARK: Work UIPicker
extension AddNewServiceVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    private func setupPicker(){ // определяет поле на которое нажали и обозначаем делегатов
        // назначаем делегата
        picker.delegate = self
        picker.dataSource = self
        
        // определяем поля ввода
        timeService.inputView = picker
        cosmetologiService.inputView = picker
        nameCategoryOfService.inputView = picker
        maleMan.inputView = picker
        partOfTheBody.inputView = picker
        
        // ставим тригеры на редактирования полей
        maleMan.addTarget(self, action: #selector(editingMaleMan(_:)), for: .editingDidBegin)
        partOfTheBody.addTarget(self, action: #selector(editingPartOfTheBody(_:)), for: .editingDidBegin)
        nameCategoryOfService.addTarget(self, action: #selector(editingNameCategoryOfService(_:)), for: .editingDidBegin)
        cosmetologiService.addTarget(self, action: #selector(editingCosmetologiService(_:)), for: .editingDidBegin)
        timeService.addTarget(self, action: #selector(editingTimeService(_ :)), for: .editingDidBegin)
    
        //
        //timeService.addTarget(self, action: #selector(editingTimeService(_ :)), for: .editingDidEndOnExit)
    }
    
    @objc func editingTimeService(_ textField: UITextField) {
        arrayPickerData.removeAll() // очищаем массив
        generateTime()
        //picker.reloadAllComponents()
    }
    
    @objc func editingCosmetologiService(_ textField: UITextField) {
        arrayPickerData.removeAll() // очищаем массив
        getDataFirebase("cosmetologis")
    }
    
    @objc func editingNameCategoryOfService(_ textField: UITextField) {
        arrayPickerData.removeAll() // очищаем массив
        //getDataFirebase("nameCategorysServices")
        let arrayCategoryResult = realm.objects(CategoryService.self)//выбираем из базы все категории
        for category in arrayCategoryResult{
            arrayPickerData.append(category.category)// заполняем массив названием категории
        }
    }
    
    @objc func editingMaleMan(_ textField: UITextField) {
        arrayPickerData.removeAll() // очищаем массив
        arrayPickerData.append("Для мужчин")
        arrayPickerData.append("Для женчин")
        arrayPickerData.append("Для всех")
        //getDataFirebase("maleMans")
    }
    
    @objc func editingPartOfTheBody (_ textField: UITextField) {
        arrayPickerData.removeAll() // очищаем массив
        getDataFirebase("partOfTheBodys")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //print(arrayPickerData.count)
        return arrayPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if timeService.isEditing{
            timeService.text = arrayPickerData[row]
        }
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
    }
    
    
    
}

// MARK: Setup Elements
extension AddNewServiceVC{
    private func setupViewElements(){
        // setup UIDatePicker
        //setupDatePicker()
        
        // setup UIImageView
        self.imageService.contentMode = .scaleAspectFill
        self.imageService.layer.cornerRadius = 40
        
        // setup saveButton
        self.saveButton.layer.cornerRadius = 10
        self.saveButton.layer.borderWidth = BorderWidth.borderWidth
        self.saveButton.layer.borderColor = ColorApp.greenComplete.cgColor
        self.saveButton.backgroundColor = ColorApp.clear
        self.saveButton.setTitleColor(ColorApp.greenComplete, for: .normal)
    }
}

// MARK: Table view
extension AddNewServiceVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMaster.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = masterTableView.dequeueReusableCell(withIdentifier: "masterCell", for: indexPath) as! CustomTVCellMaster
        cell.nameMaster.text = arrayMaster[indexPath.row].name
        cell.profilMaster.text = arrayMaster[indexPath.row].profil
        if let data = arrayMaster[indexPath.row].image{
            cell.imageMaster.image = UIImage(data: data)
        } else {
            print("Не удалось отобразить мастера")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // добавление в arrayMasterAdded
        let addItem = UIContextualAction(style: .normal, title: nil) {  [weak self](contextualAction, view, boolValue) in
            let master = self!.arrayMasterAll.remove(at: indexPath.row) // удаляем из массива всех мастеров
            self!.arrayMasterAdded.append(master) // и добавляем в массив добавленых мастеров
            self!.getArrayMaster(self!.arrayMasterAll) // обновляем массив для таблицы
        }
        addItem.backgroundColor = ColorApp.black
        addItem.image = UIImage(systemName: "plus")
        
        // удаление из arrayMasterAdded
        let deleteItem = UIContextualAction(style: .normal, title: nil) {  [weak self](contextualAction, view, boolValue) in
            let master = self!.arrayMasterAdded.remove(at: indexPath.row) // удаляем из массива добавленных мстеров
            self!.arrayMasterAll.append(master) // добавляем в массив всех мастеров
            self!.getArrayMaster(self!.arrayMasterAdded) // обновляем массив для таблицы
        }
        deleteItem.backgroundColor = ColorApp.black
        deleteItem.image = UIImage(named: "trash")
        
        if deleteOrChange{ // только удаление (из списка для услуги)
            let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem])
            swipeActions.performsFirstActionWithFullSwipe = true
            return swipeActions
        }else{ // только добавление из списка всех мастеров
            let swipeActions = UISwipeActionsConfiguration(actions: [addItem])
            swipeActions.performsFirstActionWithFullSwipe = true
            return swipeActions
        }
    }
    
}

//MARK: Updata Service
extension AddNewServiceVC{
    private func editingMode(){
        if !serviceUpdate.id.isEmpty{ // если master id не постой, то переходим в режим редактирования
            saveButton.setTitle("Обновить", for: .normal)
            nameService.text = serviceUpdate.nameService
            timeService.text = serviceUpdate.timeService
            priceService.text = serviceUpdate.placeService
            descriptionService.text = serviceUpdate.serviceDescription
            nameCategoryOfService.text = serviceUpdate.nameCategoryService
            cosmetologiService.text = serviceUpdate.comsmetology
            partOfTheBody.text = serviceUpdate.partOfTheBody
            maleMan.text = serviceUpdate.maleMan
            guard let imageData = serviceUpdate.image else {return}
            imageService.image = UIImage(data: imageData)
        }
    }
}



//extension AddNewServiceVC{
//    private func setupKeyboard(){
//        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
//        print("1")
//    }
//
//    @objc func kbDidShow( notification: Notification ){
//        guard let userInfo = notification.userInfo else {
//            return
//        }
//        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        print(kbFrameSize.height, self.view.bounds.size.height)
//        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
//
//
//
//    }
//    @objc func kbDidHide( notification: Notification ){
//
//    }
//}
    


