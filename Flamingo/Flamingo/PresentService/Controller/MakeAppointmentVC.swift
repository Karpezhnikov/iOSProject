//
//  MakeAppointmentVC.swift
//  Flamingo
//
//  Created by mac on 11/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class MakeAppointmentVC: UIViewController{
    
    let datePicker = UIDatePicker()
    var service = Service()
    var arrayMaster = Array<Master>()
    var serviceEntry = ServiceEntry()
    var cellDateDateTime: Date? = nil
    var additingNewEntry = false
    var dateEntry = Date()
    
    @IBOutlet weak var imageService: UIImageView!
    @IBOutlet weak var nameService: UILabel!
    @IBOutlet weak var nameClient: UITextField!
    @IBOutlet weak var phoneClient: UITextField!
    @IBOutlet weak var dataReceipt: UITextField!
    @IBOutlet weak var addDTTMButton: UIButton!
    @IBOutlet weak var makeButton: UIButton!
    //@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
        //setupDatePicker()
        setupKeyboard()
        checkTextFieldEmpty()
        
        phoneClient.delegate = self
        
        //self.navigationController?.navigationBar.backItem?.title = "Anything Else"
    }
    
    //MARK: Setup View Elements
    private func setupViewElements(){
        let persons = realm.objects(Person.self)
        if persons.count > 0{
            guard let person = persons.first else{return}
            self.nameClient.text = person.name
            self.phoneClient.text = person.numberPhone
        }else{
            self.nameClient.text = ""
            self.phoneClient.text = ""
        }
        
        self.nameService.text = service.nameService
        self.imageService.image = getImageService()
        
        //Table View
        self.tableView.isPagingEnabled = true
        self.tableView.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.01
        self.tableView.layer.borderColor = ColorApp.white.cgColor
        self.tableView.backgroundColor = ColorApp.white.withAlphaComponent(0.1)

        self.imageService.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.01
        self.imageService.layer.borderColor = ColorApp.white.cgColor
        self.imageService.backgroundColor = ColorApp.white.withAlphaComponent(0.1)
        
        self.makeButton.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.01
        self.makeButton.layer.borderColor = ColorApp.greenComplete.cgColor
        self.makeButton.layer.borderWidth = BorderWidth.borderWidth
        self.makeButton.backgroundColor = ColorApp.white.withAlphaComponent(0.1)
        self.makeButton.setTitleColor(ColorApp.white, for: .normal)
        self.makeButton.contentHorizontalAlignment = .center
        self.makeButton.titleLabel?.font = Font.fontSubTitle
        self.makeButton.titleLabel?.textColor = ColorApp.white.withAlphaComponent(0.5)
        
        // add Epmty fitrs item
        arrayMaster.insert(Master(), at: 0)// записываем 1 доп ячейку
        
    }

    private func getImageService() -> UIImage{
        guard service.image != nil else {
            return UIImage(named: "DSC_0698")!
        }
        let image = UIImage(data: service.image!)
        return image!
    }
    
    private func numberCorrection(){
        
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier
        else {return}
        if identifire == "selectDateAndTime"{
            guard let calendarVC = segue.destination as? CelendarVC else {return}
            calendarVC.service = service
            calendarVC.master = arrayMaster[getIdMasterEntry()]
        }
    }
    
    @IBAction func unwindToMakeAppointmentVC(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? CelendarVC{
            self.cellDateDateTime = sourceViewController.cellDateDateTime
            if let timeServiceEntry = self.cellDateDateTime{
                //replaceTitleButton(timeServiceEntry)
                dateEntry = timeServiceEntry
                dataReceipt.text = WorkTimeAndDate.dateFromConvert(timeServiceEntry, mask: "d MMMM, HH:mm")
                _ = checkDataEntry()
            }else{
                print("Not entry Time And Date")
            }
            
            
        }
        // Use data from the view controller which initiated the unwind segue
    }
    
    private func replaceTitleButton(_ date: Date){
        let titleButton = WorkTimeAndDate.dateFromConvert(date, mask: "MMM d, HH:mm")
        addDTTMButton.setTitle(titleButton, for: .normal)
        addDTTMButton.setTitleColor(ColorApp.white, for: .normal)
    }
    
    //MARK: Actions
    @IBAction func exitAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func makeAppointment(_ sender: Any) {
        
        guard checkNameClient(), checkPhoneClient(), checkDataEntry() else{return} // проверяем заполнение данных
        collectServiceEntry() //заполняем данные
        
        //ToDo: проверка на доступность интернета
        FirebaseManager.saveServiceEntryToFirebase(self.serviceEntry)
        additingNewEntry = true
        performSegue(withIdentifier: "unwindToDetailServiceVC", sender: nil)
    }
    
    //MARK: Collect Service Entry
    // для записи значений из полей
    private func collectServiceEntry(){
        let indexArrayMaster = getIdMasterEntry()
        serviceEntry.serviceName = service.nameService
        serviceEntry.serviceIdDocument = service.id
        serviceEntry.nameClient = nameClient.text ?? ""
        serviceEntry.numberPhoneClient = phoneClient.text ?? ""
        serviceEntry.idMaster = arrayMaster[indexArrayMaster].id// получаем id выбраного мастера
        serviceEntry.dttmEntry = dateEntry 
        serviceEntry.price = service.placeService //
    }
    
    // получаем индекс выбраный ячеки (индекс выбраного мастера)
    private func getIdMasterEntry()->Int{
        let tVVC = tableView.visibleCells
        if tVVC.count == 1{
            let indexPathArray = tableView.indexPath(for: tableView.visibleCells[0])
            return indexPathArray![1]
        }else{
            return 0
        }
    }
    

    
}

//MARK: Table View
extension MakeAppointmentVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMaster.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMasters", for: indexPath) as! MasterTVCell
        cell.imageMaster.layer.cornerRadius = cell.imageMaster.frame.size.width/2 //делаем из-е круглым(после того как опр-ся высота ячейки)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none // ячейка не выделяется вообще
        // в первую ячейку записываем действие пользователя
        cell.profilMaster.font = Font.fontRegular
        cell.profilMaster.textColor = ColorApp.white
        if indexPath.row == 0{
            cell.nameMaster.text = ""
            cell.timeAndPrice.text = ""
            if (arrayMaster.count - 1) == 0{
                cell.profilMaster.text = "Нет специалистов"
            }else{
                cell.profilMaster.text = "Выберите специалиста"
            }
            cell.profilMaster.font = Font.fontSubTitle
            cell.profilMaster.textColor = ColorApp.white.withAlphaComponent(0.3)
            cell.imageMaster.image = UIImage(named: "launchScr")
            return cell
        }
        cell.nameMaster.text = arrayMaster[indexPath.row].name
        cell.profilMaster.text = arrayMaster[indexPath.row].profil
        if let imageData = arrayMaster[indexPath.row].image{
            cell.imageMaster.image = UIImage(data: imageData)
        }
        cell.timeAndPrice.text = "\(service.timeService), \(service.placeService)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath[1] == 0 && arrayMaster.count > 1{ //при нажатии на выбор мастра, скролим до 1-й, чтобы показать действие
            tableView.scrollToRow(at: IndexPath(row: 1
                , section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
        }
        
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
        let minDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) // минимальная дата = данное время + 2 xfcf
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
        phoneClient.addTarget(self, action: #selector(checkPhoneClient), for: .editingDidEnd)
        dataReceipt.addTarget(self, action: #selector(checkDataEntry), for: .editingChanged)
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
        if phoneClient.text!.isEmpty || phoneClient.text!.count != 17{
            phoneClient.backgroundColor = ColorApp.redIsEmpty
            return false
        }else{
            phoneClient.backgroundColor = ColorApp.clear
        }
        return true
    }
    
    @objc func checkDataEntry()->Bool{
        if dataReceipt.text!.isEmpty{
            dataReceipt.backgroundColor = ColorApp.redIsEmpty
            return false
        }else{
            dataReceipt.backgroundColor = ColorApp.clear
        }
        return true
    }
    
}

//MARK: UITextFieldDelegate
extension MakeAppointmentVC: UITextFieldDelegate{
    
    func setupTextFieldDelegate(){
        phoneClient.delegate = self
    }
    
    //вызывается при заполнении поля (когда значение еще не записано в поле)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(number: newString)
        return false
    }
    
    // переводит в нудный формат
    private func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+X (XXX) XXX-XXXX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
}
