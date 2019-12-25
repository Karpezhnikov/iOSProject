//
//  RegistrationVC.swift
//  Flamingo
//
//  Created by mac on 23/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

// ToDo: как нибудь оповестить пользователя о созданнии профиля



class RegistrationVC: UIViewController {

    var stateView = 1
    var person = Person()
    
    @IBOutlet weak var buttonExit: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var actionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTextField.backgroundColor = ColorApp.lagthGreyColor
        infoTextField.textContentType = .name
        //actionLabel.alpha = 0.8
    }
    
    //MARK: Action Next Info
    @IBAction func nextAction(_ sender: Any) {
        guard emptyInfoTextField() else {return}
        switch stateView {
        case 1:
            person.name = infoTextField.text!
            infoTextField.text = ""
            actionLabel.text = "\(person.name), введите Ваш номер телефона?"
            stateView = 2
            infoTextField.keyboardType = .numbersAndPunctuation
            infoTextField.textContentType = .telephoneNumber
            setupTextFieldDelegate()
        case 2:
            guard checkCountNumber() else {return}
            person.numberPhone = infoTextField.text!
            DispatchQueue.global(qos: .background).async {[weak self] in
                FirebaseManager.savePersonToFirebase(self!.person)
            }
            UserDefaults.standard.set(person.name, forKey: "namePerson")
            UserDefaults.standard.set(person.numberPhone, forKey: "numberPerson")
            UserDefaults.standard.set(person.admin, forKey: "adminPerson")
            UserDefaults.standard.set(person.numberVerif, forKey: "numberVerif")
            self.dismiss(animated: true, completion: nil)
            
            //ToDo: должен быть переход на акции
            
        default:
            return
        }
    }
    
    //MARK: Action Back
    @IBAction func exitAction(_ sender: Any) {
        switch stateView {
        case 1:
            self.dismiss(animated: true, completion: nil)
        case 2:
            infoTextField.keyboardType = .default
            infoTextField.textContentType = .name
            setupNoDelagate()
            stateView = 1
            actionLabel.text = "Как к Вам обращаться?"
            infoTextField.text = "\(person.name)"
            print("Переход в первое состояние")
        default:
            return
        }
    }
    
    // проверка на количество цифр в телефоне
    private func checkCountNumber()->Bool{
        if infoTextField.text != ""{
            guard let countInfo = infoTextField.text?.count, countInfo == 17 else {
                //infoTextField.backgroundColor = ColorApp.redIsEmpty
                warningInfo()
                return false
            }
            infoTextField.backgroundColor = ColorApp.lagthGreyColor
            return true
        }else{
            return false
        }
    }
    
    // проверка на пустоту
    private func emptyInfoTextField()->Bool{
        if infoTextField.text!.isEmpty{
            warningInfo()
            return false
        }else{
            infoTextField.backgroundColor = ColorApp.lagthGreyColor
        }
        return true
    }
    
    // анимация для показа некоректно заполненного поля
    private func warningInfo(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            self!.infoTextField.backgroundColor = ColorApp.redIsEmpty
        }) { [weak self] (complete) in
            self!.infoTextField.backgroundColor = ColorApp.lagthGreyColor
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: UITextFieldDelegate
extension RegistrationVC: UITextFieldDelegate{
    
    func setupTextFieldDelegate(){
        infoTextField.delegate = self
    }
    
    func setupNoDelagate(){
        infoTextField.delegate = nil
    }
    
//    //вызывается при заполнении поля (когда значение еще не записано в поле)
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//        textField.text = formattedNumber(number: newString)
//        return false
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = formattedNumber(number: textField.text!)
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
