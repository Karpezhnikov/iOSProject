//
//  AnimateLaunchScreenVC.swift
//  Flamingo
//
//  Created by mac on 19/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//


import UIKit
import Firebase

class RegSelectionScreenVC: UIViewController {

    let animate = AnimateUI()
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var buttonNext: SetupButton!
    @IBOutlet weak var buttonRegistration: SetupButton!
    @IBOutlet weak var labelCreateAcc: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let user = UserDefaults.standard.string(forKey: "namePerson")
        setupElements()
        buttonNext.layer.cornerRadius = buttonNext.frame.size.height/2
        buttonRegistration.layer.cornerRadius = buttonRegistration.frame.size.height/2
        //buttonNext.backgroundColor = ColorApp.indigo
        //buttonRegistration.backgroundColor = ColorApp.indigo
        
        buttonRegistration.layer.borderWidth = BorderWidth.borderWidth
        buttonRegistration.layer.borderColor = ColorApp.indigo.cgColor
        
        buttonNext.layer.borderWidth = BorderWidth.borderWidth
        buttonNext.layer.borderColor = ColorApp.indigo.cgColor
        
        cleatViewController()
        animateElements()
        //buttonNext.alpha = 0.5
        //cleatViewController() // делаем все объекты невидимыми(+ даективация кнопки)
        //animateElements() // анимация элементов UI
        
    }
    
    // MARK: Clear View (alpha 0)
    private func cleatViewController(){
        logoImage.alpha = 0.0
        buttonNext.alpha = 0.0
        buttonRegistration.alpha = 0.0
        labelCreateAcc.alpha = 0.0
    }
    
    private func animateElements(){
        
        self.animate.animateAlpha(element: logoImage, toAlpha: 1.0, animateRunTime: 1)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in // через intervalAnimateTime секунды
            self!.animate.animateAlpha(element: self!.labelCreateAcc, toAlpha: 1.0, animateRunTime: 1)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in // через intervalAnimateTime секунды
            self!.animate.animateAlpha(element: self!.buttonRegistration, toAlpha: 1.0, animateRunTime: 1)
            self!.animate.animateAlpha(element: self!.buttonNext, toAlpha: 1.0, animateRunTime: 1)
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in // через intervalAnimateTime секунды
//            self!.animate.animateAlpha(element: self!.buttonNext, toAlpha: 1.0, animateRunTime: 1)
//        }
    }
    
    
    private func setupElements(){
        //buttonLogIn.layer.borderWidth = BorderWidth.borderWidth
        //buttonLogIn.layer.borderColor = ColorApp.greenComplete.cgColor
        //buttonLogIn.layer.cornerRadius = self.buttonLogIn.frame.size.width/7
        
        //buttonNext.layer.borderWidth = BorderWidth.borderWidth
        //buttonNext.layer.borderColor = ColorApp.white.cgColor
        buttonNext.tintColor = ColorApp.white
        //buttonNext.layer.cornerRadius = self.view.frame.size.width * 0.1
    }
    
    
    //private func()
    
    //MARK: Action Next
    @IBAction func startView(_ sender: Any) {
        //animate.nextViewController(viewController: self) // запускаем анимацию перехода на view
        performSegue(withIdentifier: "StartApp", sender: nil) // переходим
    }
    
    @IBAction func registrationAndSignIn(_ sender: Any){
        if let vc = UIStoryboard(name: "Registration", bundle: nil).instantiateInitialViewController() {
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }
        //performSegue(withIdentifier: "RegistrationSegue", sender: nil)
    }
    
    
    
    
    
//    // MARK: Animate Elements
//    private func animateElements(){
//        let intervalAnimateTime = 1.5 // время между анимациями
//        let animateRunTime = 1.5 // время действия анимации
//
//        animate.animateAlpha(element: flamingoLabel, toAlpha: 1.0, animateRunTime: animateRunTime) // шаг 1 - появляется название салона
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + intervalAnimateTime) { [weak self] in // через intervalAnimateTime секунды
//            self!.animate.animateAlpha(element: self!.flamingoLabel, toAlpha: 0.0, animateRunTime: 1.5)//шаг 2 - исчезает название
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + intervalAnimateTime*2) { [weak self] in
//            self!.animate.animateAlpha(element: self!.logoImage, toAlpha: 1.0, animateRunTime: 1.5) // шаг 3 - появляется логотип
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + intervalAnimateTime*2.3) { [weak self] in // шаг 4 - появляется и активируется кнопка
//            self!.buttonRegistration.isUserInteractionEnabled = true // активируем кнопку
//            self!.animate.animateAlpha(element: self!.buttonRegistration, toAlpha: 0.7, animateRunTime: 1.5)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + intervalAnimateTime*2.6) { [weak self] in // шаг 4 - появляется и активируется кнопка
//            self!.buttonLogIn.isUserInteractionEnabled = true // активируем кнопку
//            self!.animate.animateAlpha(element: self!.buttonLogIn, toAlpha: 0.7, animateRunTime: 1.5)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + intervalAnimateTime*2.9) { [weak self] in // шаг 4 - появляется и активируется кнопка
//            self!.buttonNext.isUserInteractionEnabled = true // активируем кнопку
//            self!.animate.animateAlpha(element: self!.buttonNext, toAlpha: 0.7, animateRunTime: 1.5)
//        }
//    }
    
}

        


