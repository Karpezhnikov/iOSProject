//
//  EditOnServiceViewController.swift
//  Flamingo
//
//  Created by mac on 15/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit


// ToDo: доделать дизайн + добавить поля с телефоном и именем
class EditOnServiceViewController: UIViewController {

    let datePicker = UIDatePicker()
    let picker = UIPickerView()
    var arrayPickerData = Array<String>()
    var serviceName = ""
    var masters = [MasterServices]()
    var service = Service() // выбраная услуга
    
    
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var buttonClose: SetupButton!
    
    @IBOutlet weak var titleSmallView: UILabel!
    @IBOutlet weak var nameClient: UITextField!
    @IBOutlet weak var phoneClient: UITextField!
    @IBOutlet weak var nameService: UITextField!
    @IBOutlet weak var nameMaster: UITextField!
    @IBOutlet weak var dateRecording: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //smallView.layer.cornerRadius = buttonClose.frame.size.width/2
        
        smallView.layer.borderWidth = BorderWidth.borderWidth
        smallView.layer.borderColor = ColorApp.indigo.cgColor
        
        smallView.layer.cornerRadius = buttonClose.frame.size.width/2
        
        
        titleSmallView.text = service.nameService // заполняем титул
        nameService.text = service.nameService // запоняем название услуги
        getDateFromPicker(Date()) // изначально записываем текущее время
        
        setupDatePicker() // настраиваем DatePicker
        setupToolBar() // настраиваем ToolBar
        setupPicker() // настраиваем UIPicker
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone)) //для закрытия UIPicker по клику на экран
        self.view.addGestureRecognizer(tapGesture)
        
    }
    

    // MARK: Action Close
    @IBAction func closeEditOnServiceController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Work UIPicker
extension EditOnServiceViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    private func setupPicker(){ // определяет поле на которое нажали и обозначаем делегатов
        picker.delegate = self
        picker.dataSource = self
        // в зависимости от нажатого поля заполняем массив для picker
        nameMaster.addTarget(self, action: #selector(editingBeganMaster(_:)), for: .editingDidBegin)
        nameService.addTarget(self, action: #selector(editingBeganServices(_:)), for: .editingDidBegin)
        
    }
    
    @objc func editingBeganMaster(_ textField: UITextField) {
        arrayPickerData.removeAll() // очищаем массив
        nameMaster.inputView = picker // для появления поля по нажатию на nameMaster
        getMastersName() // быбираем всез мастеров и записываем в массив arrayPickerData
        picker.reloadAllComponents() // обновляем список компонентов
    }
    
    @objc func editingBeganServices (_ textField: UITextField) {
        arrayPickerData.removeAll() // очищаем массив
        nameService.inputView = picker // для появления поля по нажатию на nameService
        arrayPickerData.append(service.nameService)
        picker.reloadAllComponents() // обновляем список компонентов
    }
    
    private func getMastersName(){
        for master in masters{
            arrayPickerData.append(master.nameMaster)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if nameMaster.isEditing{ // смотрим какое поле сейчас редактируется
            nameMaster.text = arrayPickerData[row]
        }else if nameService.isEditing{
            nameService.text = arrayPickerData[row]
        }
        return arrayPickerData[row]
    }
    
    
}

// MARK: Setup DatePicker
extension EditOnServiceViewController{
    private func setupDatePicker(){
        dateRecording.inputView = datePicker //для того, чтобы пикер появлялся по нажатию на поле
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
        dateRecording.text = formatter.string(from: date) // записываем дату в dateRecording
    }
}

// MARK: Setup ToolBar
extension EditOnServiceViewController{
    
    private func setupToolBar(){
        let toolBar = UIToolbar() // создаем тул бар для добавления кнопки готово
        toolBar.sizeToFit()
        toolBar.translatesAutoresizingMaskIntoConstraints = true
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction)) // создаем кнопку готово
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // создаем кнопку чтобы поместить кнопку "готово" слева
        
        toolBar.setItems([flexSpace, doneButton], animated: true) // вставляем кпонки в тул бар
        dateRecording.inputAccessoryView = toolBar // для реагирование на кнопку тул бара
        nameService.inputAccessoryView = toolBar
        nameMaster.inputAccessoryView = toolBar
    }
    
    @objc func doneAction(){
        view.endEditing(true)
    }
}
