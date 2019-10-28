//
//  ViewController.swift
//  ToDoFire
//
//  Created by Алексей Карпежников on 24/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    let segueIdentifire = "tasksSegue"
    var ref: DatabaseReference!
    
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "users")
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        warnLabel.alpha = 0
        
        // для автоматического ввода (после рагистрации или входа)
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil{
                self?.performSegue(withIdentifier: (self?.segueIdentifire)!, sender: nil)
            }
        }
    }
    
    // метод выполняется перед viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = "" // очищаем поле
        passwordTextField.text = "" // очищаем поле
    }

    @objc func kbDidShow(notification: Notification){
        guard let userInfo = notification.userInfo else {return}
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    
    
    @objc func kbDidHide(notification: Notification){
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    func displayWarningLabel(withText text: String){
        warnLabel.text = text
        UIView.animate(withDuration: 3, delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [.curveEaseOut],
                       animations: { [weak self] in
                            self?.warnLabel.alpha = 1
                        }) { [weak self] complete in
                            self?.warnLabel.alpha = 0
                        }
    }
    
    // метод для входа
    @IBAction func loginTapped(_ sender: UIButton) {
        // проверяем запонение полей
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != ""
            else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        // логинимся
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil{
                self?.displayWarningLabel(withText: "Error accured")
                return
            }
            if user != nil{
                self?.performSegue(withIdentifier: (self?.segueIdentifire)!, sender: nil)
                return
            }
            self?.displayWarningLabel(withText: "No such user")
        }
    }
    @IBAction func registerTapped(_ sender: UIButton) {
        // проверяем запонение полей
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != ""
            else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            
            guard error == nil, user != nil else{
                print(error?.localizedDescription)
                return
            }
            let userRef = self?.ref.child((user?.user.uid)!)
            userRef?.setValue(["email":user?.user.email])
        }
    }
    
    

    
}

