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
    @IBOutlet weak var nameClientReg: SetupTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTextField.text = ""
        infoTextField.keyboardType = .numbersAndPunctuation
        infoTextField.textContentType = .telephoneNumber
        
        buttonNext.backgroundColor = ColorApp.white.withAlphaComponent(0.2)
        buttonNext.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.01
        
        setupTextFieldDelegate()
        
    }
    
    //MARK: Action Next Info
    @IBAction func nextAction(_ sender: Any) {
        guard checkName() else {return} // проверка на пустое имя
        guard checkCountNumber() else {return} // проверка на пустой телефон
        person.name = nameClientReg.text!
        person.numberPhone = infoTextField.text!
        print("Check number of Firebase (Spark)") // будет проверка номера
        checkDataNumberPhone(infoTextField.text!) // проверка на существующий аккаунт
    }
    
    // проверяем данные по номеру
    private func checkDataNumberPhone(_ number: String){
        FirebaseManager.firebaseBD.collection("users").whereField("numberPhone", isEqualTo: "\(number)")
            .getDocuments() { [weak self](querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let documents = querySnapshot!.documents
                    guard documents.count > 0 else {
                        // если данных нет (то создаем нового пользователя)
                        FirebaseManager.savePersonToFirebase(self!.person)
                        StorageManager.saveObject(self!.person)
                        self!.performSegue(withIdentifier: "unwindToAccauntVC", sender: nil)
                        return}
                    let data = documents.first?.data()
                    //если такой пользователь есть, то сохраняем его
                    self!.person.name = data!["name"] as! String
                    self!.person.numberPhone = data!["numberPhone"] as! String
                    self!.person.numberVerif = true
                    self!.person.admin = data!["admin"] as! Bool
                    StorageManager.saveObject(self!.person)
                    self!.performSegue(withIdentifier: "unwindToAccauntVC", sender: nil)
                }
        }
    }
    
    //MARK: Action Back
    @IBAction func exitAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // проверка на количество цифр в телефоне
    private func checkCountNumber()->Bool{
        if infoTextField.text != ""{
            guard let countInfo = infoTextField.text?.count, countInfo == 17 else {
                warningInfo()
                return false
            }
            infoTextField.backgroundColor = ColorApp.lagthGreyColor
            return true
        }else{
            warningInfo()
            return false
        }
    }
    
    private func checkName()->Bool{
        if infoTextField.text != ""{
            infoTextField.backgroundColor = ColorApp.lagthGreyColor
            return true
        }else{
            warningInfo()
            return false
        }
    }
    
    //MARK: Animate
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
    
    //вызывается при заполнении поля (когда значение еще не записано в поле)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(number: newString)
        return false
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.text = formattedNumber(number: textField.text!)
//    }
    
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



