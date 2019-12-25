//
//  RegistrationVC.swift
//  Flamingo
//
//  Created by mac on 23/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    let nextViewSegue = "loginSegue"
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.alpha = 0
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil{
                self!.performSegue(withIdentifier: self!.nextViewSegue, sender: nil)
            }
        }
    }
    
    //MARK: ACTION: Login
    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel("Info is incorrect")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self]  (user, error) in
            if error != nil{
                self!.displayWarningLabel("Error occured")
                return
            }
            if user != nil {
                self!.performSegue(withIdentifier: self!.nextViewSegue, sender: nil)
                return
            }else{
                self!.displayWarningLabel("No such user")
            }
        }
    }
    
    //MARK: ACTION: Register
    @IBAction func registerTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel("Info is incorrect")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if error == nil{
                if user != nil{
                    self!.performSegue(withIdentifier: self!.nextViewSegue, sender: nil)
                }
            }
        }
    }
    
    private func displayWarningLabel(_ text: String){
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self!.warningLabel.text = text
            self!.warningLabel.alpha = 1
        }) { [weak self] (complete) in
            self!.warningLabel.alpha = 0
        }
    }
    
}
//MARK: Setup Keyboard
extension LoginVC{
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
