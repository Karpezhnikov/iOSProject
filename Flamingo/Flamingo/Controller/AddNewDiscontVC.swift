//
//  AddNewDiscontVC.swift
//  Flamingo
//
//  Created by mac on 26/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

// ToDo: сделать так, чтобы клавиатура не закрывала экран, доделать редактирование и обновление таблицы при возврате

import UIKit
import Firebase
import FirebaseStorage

class AddNewDiscontVC: UIViewController {

    let datePicker = UIDatePicker()
    var imageURL = ""
    var discont = DiscontFireBase()
    var discontUpdate = DiscontFireBase() // если заполнена - то в режим редакторования
    let actionSheet = UIAlertController(title: nil, message: "", preferredStyle: .alert)
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameDiscont: UITextField!
    @IBOutlet weak var dateStart: UITextField!
    @IBOutlet weak var dateEnd: UITextField!
    @IBOutlet weak var discriptionDiscont: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements() // настраиваем эле-ты на view
        checkTextFieldEmpty() // вызываем тригеры на заполнение полей
        // setup keyboard
        //setupKeyboard()
        addDoneButtonOnKeyboard()
        editingMode() // переводим в режим редактирования, если discontUpdate есть
        
    }
    
    // MARK: Setup Elements
    private func setupViewElements(){
        // setup UIDatePicker
        setupDatePicker()
        
        // setup UIImageView
        self.image.contentMode = .scaleToFill
        self.image.layer.cornerRadius = 40
        
        // setup UITextView
        self.discriptionDiscont.layer.cornerRadius = nameDiscont.layer.cornerRadius
        self.discriptionDiscont.layer.borderWidth = nameDiscont.layer.borderWidth
        self.discriptionDiscont.layer.borderColor = nameDiscont.layer.borderColor
        self.discriptionDiscont.font = Font.fontRegular
        
        // setup saveButton
        if !discontUpdate.id.isEmpty{
            self.saveButton.setTitle("Обновить", for: .normal)
        }else{
            self.saveButton.setTitle("Добавить", for: .normal)
        }
        self.saveButton.layer.cornerRadius = 10
        self.saveButton.layer.borderWidth = BorderWidth.borderWidth
        self.saveButton.layer.borderColor = ColorApp.greenComplete.cgColor
        self.saveButton.backgroundColor = ColorApp.clear
        self.saveButton.setTitleColor(ColorApp.greenComplete, for: .normal)
    }
    
    private func editingMode(){
        
        if !discontUpdate.name.isEmpty{
            nameDiscont.text = discontUpdate.name
            dateStart.text = discontUpdate.dateStart
            dateEnd.text = discontUpdate.dateEnd
            discriptionDiscont.text = discontUpdate.descriptionDiscont
        }
        guard discontUpdate.image != nil else {
            return
        }
        image.image = UIImage(data: discontUpdate.image!)
        
    }
    
    //MARK: Check data to TextField
    private func checkTextFieldEmpty(){
        nameDiscont.addTarget(self, action: #selector(checkNameDiscont), for: .editingDidEnd) // тригер на заполнение
        dateStart.addTarget(self, action: #selector(checkDateStart), for: .editingDidEnd) // тригер на заполнение
        dateEnd.addTarget(self, action: #selector(checkDateEnd), for: .editingDidEnd) // тригер на заполнение

    }
    
    @objc func checkNameDiscont(){
        if nameDiscont.text!.isEmpty{
        }else{
            nameDiscont.backgroundColor = ColorApp.greenComplete
        }
    }
    
    @objc func checkDateStart(){
        if dateStart.text!.isEmpty || dateStart.text == dateEnd.text{
        }else{
            dateStart.backgroundColor = ColorApp.greenComplete
        }
    }
    
    @objc func checkDateEnd(){
        if dateEnd.text!.isEmpty || dateStart.text == dateEnd.text{
        }else{
            dateEnd.backgroundColor = ColorApp.greenComplete
        }
    }
    
    
    // MARK: Add Image
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
    
    
    
    
    
    
    @IBAction func saveDiscont(_ sender: Any) {
        saveButton.isUserInteractionEnabled = false //делаем кнопку не активной
        saveButton.alpha = 0.5 //делаем кнопку не активной
        
        if !self.discontUpdate.id.isEmpty{ //если кнопка сохранить нажата в режиме редактирования, то
            FirebaseManager.deleteDocument(discontUpdate.id, discontUpdate.imageURL, "disconts", "discont_images")
            saveDataToFireBase() // сохраняем как новую запись в FireBase
        }else{
            saveDataToFireBase()
        }
        
        
        
    }
    
    // MARK: Save Data to Firebase
    private func saveDataToFireBase(){
        saveImageToFirebaseStorage() // получаем URL изображения
        collectDiscont() // наполняем discont (точно уверены что все поля заполнены)

        actionSheet.message = "Подождите..." // создаем уведомление о процессе загрузки
        present(actionSheet, animated: true)
        
        print("URL is Empty.", "Saving is in progress!")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in // ждем 5 секунд, чтобы успел придти imageURL
            guard !self!.discont.imageURL.isEmpty else { // проверяем на то, что imageURL заполнен
                self!.saveButton.isUserInteractionEnabled = true
                self!.saveButton.alpha = 1
                self!.actionSheet.message = "Не удалось сохранить. Попробуйте еще раз."
                let cancel = UIAlertAction(title: "ОК", style: .cancel)
                self!.actionSheet.addAction(cancel)
                return
            }
            FirebaseManager.saveDiscontToFirebase(self!.discont)
            //StorageManager.saveObjectDiscount(self!.discont)
            self!.actionSheet.message = "Сохранено"
            // ToDo: Обновление
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // через секунду закрываем actionSheet и view
                self!.actionSheet.dismiss(animated: true)
                //self!.dismiss(animated: true, completion: nil)
                self!.performSegue(withIdentifier: "backToDiscont", sender: nil)
            }
            
            
        }
    }
    
    
//    private func dataForSaveToRealm(){
//        let saveRealmDiscont = DiscontFireBase()
//        discont.id = ""
//        discont.name = nameDiscont.text!
//        discont.descriptionDiscont = discriptionDiscont.text!
//        discont.dateStart = dateStart.text!
//        discont.dateEnd = dateEnd.text!
//    }

    
    private func collectDiscont(){
        // наполняем discont (точно уверены что все поля заполнены)
        discont.id = ""
        discont.name = nameDiscont.text!
        discont.descriptionDiscont = discriptionDiscont.text!
        discont.dateStart = dateStart.text!
        discont.dateEnd = dateEnd.text!
    }
    
}

// MARK: Setup DatePicker
extension AddNewDiscontVC{
    private func setupDatePicker(){
        
        dateChanged()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone)) //для закрытия UIPicker по клику на экран
        self.view.addGestureRecognizer(tapGesture)
        
        dateStart.inputView = datePicker //для того, чтобы пикер появлялся по нажатию на поле
        dateEnd.inputView = datePicker //для того, чтобы пикер появлялся по нажатию на поле
        datePicker.datePickerMode = .date //запись даты и времени
        let localeID = Locale.preferredLanguages.first // определяем локацию для времени
        datePicker.locale = Locale(identifier: localeID!) // устанавливаем локацию в dataPIcker
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged) // тригер срабатывает при изменении значения в datePicker
        let minDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) // минимальная дата = данное время + 2 xfcf
        //let maxDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) // максимальная данное время + 30 дней
        datePicker.minimumDate = minDate
        //datePicker.maximumDate = maxDate
    }
    
    @objc func dateChanged(){ // для записи в dateStart и dateEnd
        if dateStart.isEditing{ // если изменяем dateStart
            getDateFromPicker(datePicker.date, dateStart)
            //datePicker.minimumDate = datePicker.date //
        }else if dateEnd.isEditing{ // если изменяем dateEnd
            getDateFromPicker(datePicker.date, dateEnd)
        }else{ // при первой нажатии записываем текущую дату
            getDateFromPicker(datePicker.date, dateStart)
            getDateFromPicker(datePicker.date, dateEnd)
        }
    }
    
    @objc func tapGestureDone(){ // для закрытия пикера по тапу на любую часть экрана
        view.endEditing(true)
    }
    
    private func getDateFromPicker(_ date: Date,_ element: UITextField){
        let formatter = DateFormatter() //  создаем форматер
        formatter.dateFormat = "dd.MM" // создаем формат даты и времени
        let localeID = Locale.preferredLanguages.first // определяем локацию для времени
        formatter.locale = Locale(identifier: localeID!)
        element.text = formatter.string(from: date) // записываем дату в dateStart
    }
}

// MARK: Firebase
extension AddNewDiscontVC{
    // save image and get URL image path
    private func saveImageToFirebaseStorage(){
        let imageName = (nameDiscont.text == "") ? "imageDiscont": nameDiscont.text  // создаем имя для картинки по названию акции
        let storage = Storage.storage().reference().child("discont_images") // получаем доступ к папке
        let ref = storage.child(imageName!) // кладем изображения по пути
        
        if let uploadData = image.image?.jpegData(compressionQuality: 0.2){ // переводим изображение в NSData
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
                    self!.discont.imageURL = url!.absoluteString // получаем url изображения
                    
                }
            }
        }
    }
}

// MARK: KeyBoard
extension AddNewDiscontVC{
    // add Button Готово
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.nameDiscont.inputAccessoryView = doneToolbar
        self.discriptionDiscont.inputAccessoryView = doneToolbar
        self.dateStart.inputAccessoryView = doneToolbar
        self.dateEnd.inputAccessoryView = doneToolbar
        
    }

    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
}
//extension AddNewDiscontVC{
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
//        print("2")
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

// MARK: Work with image
extension AddNewDiscontVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        image.image = info[.editedImage] as? UIImage // присваиваем отредактирование изображение
        image.contentMode = .scaleAspectFit // распределяем изображение по формату
        image.clipsToBounds = true // обрезаем границы
        dismiss(animated: true)
    }
    
}

