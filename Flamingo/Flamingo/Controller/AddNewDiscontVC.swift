//
//  AddNewDiscontVC.swift
//  Flamingo
//
//  Created by mac on 26/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

// ToDo: сделать так, чтобы клавиатура не закрывала экран

import UIKit
import Firebase
import FirebaseStorage

class AddNewDiscontVC: UIViewController {

    let datePicker = UIDatePicker()
    var imageURL = ""
    var discont = DiscontFireBase()
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameDiscont: UITextField!
    @IBOutlet weak var dateStart: UITextField!
    @IBOutlet weak var dateEnd: UITextField!
    
    @IBOutlet weak var discriptionDiscont: UITextView!
    @IBOutlet weak var saveButton: UIButton!{
        didSet{
            saveButton.isUserInteractionEnabled = false
            saveButton.alpha = 0.5
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker() // настраиваем UIDatePicker для dateStart и dateEnd
        checkTextFieldEmpty() // вызываем тригеры на заполнение полей
        
        // setup UITextView
        discriptionDiscont.layer.cornerRadius = nameDiscont.layer.cornerRadius
        discriptionDiscont.layer.borderWidth = nameDiscont.layer.borderWidth
        discriptionDiscont.layer.borderColor = nameDiscont.layer.borderColor
        discriptionDiscont.font = Font.fontRegular
        
        // setup keyboard
        //setupKeyboard()
        addDoneButtonOnKeyboard()
        
    }
    
    
    //MARK: Check data to TextField
    private func checkTextFieldEmpty(){
        nameDiscont.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd) // тригер на заполнение
        dateStart.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd) // тригер на заполнение
        dateEnd.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd) // тригер на заполнение
    }
    
    @objc func textFieldDidChange() { // проверка на заполненые поля
        guard nameDiscont.text != "" else{
            saveButton.isUserInteractionEnabled = false
            saveButton.alpha = 0.5
            nameDiscont.backgroundColor = ColorApp.lagthGreyColor
            return
        }
        nameDiscont.backgroundColor = ColorApp.greenComplete
            
        guard discriptionDiscont.text != "" else{
            saveButton.isUserInteractionEnabled = false
            saveButton.alpha = 0.5
            discriptionDiscont.backgroundColor = ColorApp.lagthGreyColor
            return
        }
        discriptionDiscont.backgroundColor = ColorApp.greenComplete
        
        guard dateStart.text != "" && dateStart.text != dateEnd.text else{
            saveButton.isUserInteractionEnabled = false
            saveButton.alpha = 0.5
            dateStart.backgroundColor = ColorApp.lagthGreyColor
            return
        }
        dateStart.backgroundColor = ColorApp.greenComplete
        
        guard dateEnd.text != "" && dateStart.text != dateEnd.text else{
            saveButton.isUserInteractionEnabled = false
            saveButton.alpha = 0.5
            dateEnd.backgroundColor = ColorApp.lagthGreyColor
            return
        }
        dateEnd.backgroundColor = ColorApp.greenComplete
        
        guard !nameDiscont.text!.isEmpty || !dateStart.text!.isEmpty || !dateEnd.text!.isEmpty || discriptionDiscont.text == "" else{
            saveButton.isUserInteractionEnabled = false
            saveButton.alpha = 0.5
            return
        }
        // если все заполнено, то делаем кнопку активной
        saveButton.isUserInteractionEnabled = true
        saveButton.alpha = 1
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
    
    
    // MARK: Save Data to Firebase
    @IBAction func saveDiscont(_ sender: Any) {
        imageUploadToFirebaseStorage() // получаем URL изображения
        
        // наполняем discont (точно уверены что все поля заполнены)
        discont.id = "1"
        discont.name = nameDiscont.text!
        discont.description = discriptionDiscont.text!
        discont.dateStart = dateStart.text!
        discont.dateEnd = dateEnd.text!
        
        saveButton.isUserInteractionEnabled = false
        saveButton.alpha = 0.5
        
        // создаем уведомление о процессе загрузки
        let actionSheet = UIAlertController(title: nil, message: "Подождите...", preferredStyle: .alert)
        present(actionSheet, animated: true)
        
        print("URL is Empty.", "Saving is in progress!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in // ждем 5 секунд, чтобы успел придти imageURL
            guard !self!.imageURL.isEmpty else { // проверяем на то, что imageURL заполнен
                self!.saveButton.isUserInteractionEnabled = true
                self!.saveButton.alpha = 1
                let cancel = UIAlertAction(title: "ОК", style: .cancel)
                actionSheet.addAction(cancel)
                actionSheet.message = "Не удалось сохранить. Попробуйте еще раз."
                return
            }
            self!.discont.imageURL = self!.imageURL // вставляем ссылку на изображение
            self!.saveDiscontToFirebase() // сохраняем в firebase
            actionSheet.message = "Сохранено"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // через секунду закрываем actionSheet и view
                //actionSheet.message = "Поменял"
                actionSheet.dismiss(animated: true)
                self!.dismiss(animated: true, completion: nil)
            }
            
            
        }
        
        
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
            datePicker.minimumDate = datePicker.date //
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
        formatter.dateFormat = "EEEE, dd.MM" // создаем формат даты и времени
        let localeID = Locale.preferredLanguages.first // определяем локацию для времени
        formatter.locale = Locale(identifier: localeID!)
        element.text = formatter.string(from: date) // записываем дату в dateStart
    }
}

// MARK: Firebase
extension AddNewDiscontVC{
    // save image and get URL image path
    private func imageUploadToFirebaseStorage(){
        let imageName = nameDiscont.text // создаем имя для картинки по названию акции
        let storage = Storage.storage().reference().child("discont_images") // получаем доступ к папке
        let ref = storage.child(imageName!) // кладем изображения по пути
        
        if let uploadData = image.image?.jpegData(compressionQuality: 0.2){ // переводим изображение в NSData
            ref.putData(uploadData, metadata: nil) { (metadata, error) in // добавляем изображение
                if error != nil{
                    print(error!)
                    return
                }
                ref.downloadURL { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    self.imageURL = url!.absoluteString // получаем url изображения
                }
            }
        }
    }
    
    // save discont
    private func saveDiscontToFirebase(){
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("disconts").addDocument(data: [
            "id":discont.id,
            "name": discont.name,
            "description": discont.description,
            "dateStart": discont.dateStart,
            "dateEnd": dateEnd.text!,
            "image": imageURL
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
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

