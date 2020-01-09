//
//  AddNewMasterVC.swift
//  Flamingo
//
//  Created by mac on 09/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import Firebase

class AddNewMasterVC: UIViewController {

    var master = Master()
    let actionSheet = UIAlertController(title: nil, message: "", preferredStyle: .alert)
    var masterUpdate = Master()
    var viewFlg = false
    
    @IBOutlet weak var imageMaster: UIImageView!
    @IBOutlet weak var nameMaster: UITextField!
    @IBOutlet weak var profilMaster: UITextField!
    @IBOutlet weak var infoMaster: UITextView!
    @IBOutlet weak var tableViewMasterServices: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var photoButton: SetupButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements() // сначала устанавливаем все элементы
        editingMode() // потом определяем режим
        presentViewSetup()
    }
    
    @IBAction func exitView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Action: Save Button
    @IBAction func saveMaster(_ sender: Any) {
        // создаем уведомление о процессе загрузки
        actionSheet.message = "Подождите..."
        present(actionSheet, animated: true)
        // сохранием документ
        collectMaster() // наполняем discont (точно уверены что все поля заполнены)
        saveImageToFirebaseStorage() // получаем URL изображения
        // если режим редактирования, то удаляем старый документ
//        if !masterUploud.id.isEmpty{
//            FirebaseManager.deleteDocument(masterUploud.id, masterUploud.imageURL, "masters", "master_images")
//        }
    }
    
    
    // MARK: Action: Get Photo
    @IBAction func getPhotoMaster(_ sender: Any) {
        getImage()
    }
    
}

// MARK: Work with image
extension AddNewMasterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        
        imageMaster.image = info[.editedImage] as? UIImage // присваиваем отредактирование изображение
        imageMaster.contentMode = .scaleAspectFit // распределяем изображение по формату
        imageMaster.clipsToBounds = true // обрезаем границы
        
        dismiss(animated: true)
    }
    
    
    
}

// MARK: Table view
extension AddNewMasterVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

// MARK: Setup View Elements
extension AddNewMasterVC{
    private func setupViewElements(){
        // Setup TextField
        self.nameMaster.font = Font.fontSubTitle
        
        // setup UIImageView
        self.imageMaster.contentMode = .scaleToFill
        self.imageMaster.layer.cornerRadius = 40
        
        // setup UITextView
        self.infoMaster.layer.cornerRadius = nameMaster.layer.cornerRadius
        self.infoMaster.layer.borderWidth = nameMaster.layer.borderWidth
        self.infoMaster.layer.borderColor = nameMaster.layer.borderColor
        self.infoMaster.backgroundColor = ColorApp.black
        self.infoMaster.textColor = ColorApp.white
        self.infoMaster.font = Font.fontRegular
        
        // setup saveButton
        self.saveButton.layer.cornerRadius = 10
        self.saveButton.layer.borderWidth = BorderWidth.borderWidth
        self.saveButton.layer.borderColor = ColorApp.greenComplete.cgColor
        self.saveButton.backgroundColor = ColorApp.clear
        self.saveButton.setTitleColor(ColorApp.greenComplete, for: .normal)
        self.saveButton.setTitle("Сохранить", for: .normal)
    }
}


// MARK: Firebase
extension AddNewMasterVC{
    // save image and get URL image path
    private func saveImageToFirebaseStorage(){
        let imageName = (nameMaster.text == "") ? "imageDiscont": nameMaster.text  // создаем имя для картинки по названию акции
        let storage = Storage.storage().reference().child("master_images") // получаем доступ к папке
        let ref = storage.child(imageName!) // кладем изображения по пути
        
        if let uploadData = imageMaster.image?.jpegData(compressionQuality: 0.2){ // переводим изображение в NSData
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
                    self!.master.imageURL = url!.absoluteString // получаем url изображения
                    guard self!.master.imageURL != "" else{
                        self!.saveButton.isUserInteractionEnabled = true
                        self!.saveButton.alpha = 1
                        self!.actionSheet.message = "Не удалось сохранить. Попробуйте еще раз."
                        let cancel = UIAlertAction(title: "ОК", style: .cancel)
                        self!.actionSheet.addAction(cancel)
                        return} // проверяем на пустуб строку в ответе
                    if !self!.masterUpdate.id.isEmpty{ //если режим редактирования, то обновляем данные в документа
                        print("dasdasdasdasd", self!.masterUpdate.id)
                        FirebaseManager.updataMaster(self!.master, idDocument: self!.masterUpdate.id, imageURLDel: self!.masterUpdate.imageURL)
                    }else{
                        FirebaseManager.saveMasterToFirebase(self!.master) // сохраняем мастера на Firebase
                    }
                    // editingMode
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
    
    private func collectMaster(){
        master.name = nameMaster.text ?? ""
        master.profil = profilMaster.text ?? ""
        master.info = infoMaster.text ?? ""
    }
    
    // MARK: Editing Mode
    private func editingMode(){
        print(masterUpdate)
        if !masterUpdate.id.isEmpty{ // если master id не постой, то переходим в режим редактирования
            saveButton.setTitle("Обновить", for: .normal)
            nameMaster.text = masterUpdate.name
            profilMaster.text = masterUpdate.profil
            infoMaster.text = masterUpdate.info
            guard let imageData = masterUpdate.image else {return}
            imageMaster.image = UIImage(data: imageData)
        }
    }
}


//MARK: ViewFlg
extension AddNewMasterVC{
    private func presentViewSetup(){
        print(master)
        if !master.id.isEmpty{ // если master id не пустой, то переходим в режим показа
            // отключаем кнопки
            self.saveButton.isUserInteractionEnabled = false
            self.saveButton.isHidden = true
            self.photoButton.isUserInteractionEnabled = false
            self.photoButton.isHidden = true
            
            self.infoMaster.layer.borderWidth = 0
            self.infoMaster.isUserInteractionEnabled = false
            self.nameMaster.layer.borderWidth = 0
            self.nameMaster.isUserInteractionEnabled = false
            self.profilMaster.layer.borderWidth = 0
            self.profilMaster.isUserInteractionEnabled = false
            
            //заполняем данные
            self.nameMaster.text = master.name
            self.profilMaster.text = master.profil
            self.infoMaster.text = master.info
            guard let imageData = master.image else {return}
            self.imageMaster.image = UIImage(data: imageData)
        }
    }
}
