//
//  MakeAppointmentVC.swift
//  Flamingo
//
//  Created by mac on 11/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class MakeAppointmentVC: UIViewController {
    
    let datePicker = UIDatePicker()
    var service = Service()
    var arrayMaster = Array<Master>()
    
    
    @IBOutlet weak var imageService: UIImageView!
    @IBOutlet weak var nameService: UILabel!
    @IBOutlet weak var nameClient: UITextField!
    @IBOutlet weak var phoneClient: UITextField!
    @IBOutlet weak var dataReceipt: UITextField!
    @IBOutlet weak var makeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
        setupDatePicker()
        setupKeyboard()
        checkTextFieldEmpty()
    }
    
    //MARK: Setup View Elements
    private func setupViewElements(){
        self.nameService.text = service.nameService
        self.imageService.image = getImageService()
        
        self.collectionView.isPagingEnabled = true
        self.collectionView.delegate = self
        
        // setup saveButton
        self.makeButton.layer.cornerRadius = 10
        self.makeButton.layer.borderWidth = BorderWidth.borderWidth
        self.makeButton.layer.borderColor = ColorApp.greenComplete.cgColor
        self.makeButton.backgroundColor = ColorApp.clear
        self.makeButton.setTitleColor(ColorApp.greenComplete, for: .normal)
    }

    private func getImageService() -> UIImage{
        guard service.image != nil else {
            return UIImage(named: "DSC_0698")!
        }
        let image = UIImage(data: service.image!)
        return image!
    }
    
    @IBAction func makeAppointment(_ sender: Any) {
        // проверяем заполнение данных
        guard checkNameClient(), checkPhoneClient() else{return}
    }
    
}

// MARK: - Collection View data source
extension MakeAppointmentVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayMaster.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "masterItem", for: indexPath) as? CustumCVCDeteil{
            
            if indexPath.row == 0{
                itemCell.nameMaster.text = ""
                itemCell.profilMaster.text = "Выберите специалиста"
                itemCell.timeAndPriceMaster.text = ""
                itemCell.imageMaster.image = UIImage(named: "launchScr")
                
                return itemCell
            }
            let indexPath = indexPath.row - 1
            itemCell.nameMaster.text = arrayMaster[indexPath].name
            itemCell.profilMaster.text = arrayMaster[indexPath].profil
            itemCell.timeAndPriceMaster.text = "\(service.timeService), \(service.placeService)"
            itemCell.imageMaster.image = UIImage(data: arrayMaster[indexPath].image!)
            return itemCell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        let sizeItem = flowLayout.itemSize
        let topSize = (collectionView.frame.size.height - (sizeItem.height + flowLayout.minimumInteritemSpacing))/2
        
        return UIEdgeInsets(top: topSize, left: 0, bottom: 0, right: 0)
    }
    
}

// MARK: Setup DatePicker
extension MakeAppointmentVC{
    private func setupDatePicker(){
        dataReceipt.inputView = datePicker //для того, чтобы пикер появлялся по нажатию на поле
        datePicker.datePickerMode = .dateAndTime //запись даты и времени
        let localeID = Locale.preferredLanguages.first // определяем локацию для времени
        datePicker.locale = Locale(identifier: localeID!) // устанавливаем локацию в dataPIcker
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged) // тригер срабатывает при изменении значения в datePicker
        let minDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date()) // минимальная дата = данное время + 2 xfcf
        let maxDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) // максимальная данное время + 30 дней
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
    }
    
    @objc func dateChanged(){ // для записи в dateRecording
        getDateFromPicker(datePicker.date)
    }
    
    @objc func tapGestureDone(){ // для закрытия пикера по тапу на любую часть экрана
        view.endEditing(true)
    }
    
    private func getDateFromPicker(_ date: Date){
        let formatter = DateFormatter() //  создаем форматер
        formatter.dateFormat = "EEEE, dd.MM, HH:mm" // создаем формат даты и времени
        let localeID = Locale.preferredLanguages.first // определяем локацию для времени
        formatter.locale = Locale(identifier: localeID!)
        dataReceipt.text = formatter.string(from: date) // записываем дату в dateRecording
    }
}

//MARK: Setup Keyboard
extension MakeAppointmentVC{
    private func setupKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc func kbDidShow( notification: Notification ){
        guard let userInfo = notification.userInfo else {
            return
        }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
    }
    @objc func kbDidHide( notification: Notification ){
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
}


// MARK: Check isEmpty TextField
extension MakeAppointmentVC{
    private func checkTextFieldEmpty(){
        nameClient.addTarget(self, action: #selector(checkNameClient), for: .editingChanged)
        phoneClient.addTarget(self, action: #selector(checkPhoneClient), for: .editingChanged)
    }
    
    @objc func checkNameClient()->Bool{
        if nameClient.text!.isEmpty{
            nameClient.backgroundColor = ColorApp.redIsEmpty
            return false
        }else{
            nameClient.backgroundColor = ColorApp.clear
        }
        return true
    }
    
    @objc func checkPhoneClient()->Bool{
        if phoneClient.text!.isEmpty{
            phoneClient.backgroundColor = ColorApp.redIsEmpty
            return false
        }else{
            phoneClient.backgroundColor = ColorApp.clear
        }
        return true
    }
}
