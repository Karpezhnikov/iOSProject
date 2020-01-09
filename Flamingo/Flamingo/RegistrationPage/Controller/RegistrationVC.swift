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
        infoTextField.text = ""
        actionLabel.text = "Введите Ваш номер телефона?"
        infoTextField.keyboardType = .numbersAndPunctuation
        infoTextField.textContentType = .telephoneNumber
        setupTextFieldDelegate()
        
    }
    
    //MARK: Action Next Info
    @IBAction func nextAction(_ sender: Any) {
        guard checkCountNumber() else {return}
        
        print("Check number of Firebase (Spark)")
        FirebaseManager.checkDataNumberPhone(infoTextField.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Action Back
    @IBAction func exitAction(_ sender: Any) {
        let presentedBy = presentingViewController as? PersonAccountVC
        presentedBy?.update1233()
        presentedBy?.viewWillAppear(true)
    
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



