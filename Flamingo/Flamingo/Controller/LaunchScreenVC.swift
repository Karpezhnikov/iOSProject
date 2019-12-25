//
//  AnimateLaunchScreenVC.swift
//  Flamingo
//
//  Created by mac on 19/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//


import UIKit
import Firebase

//MARK: ToDo: добавить окна "Вход" и "Регистрация"
class LaunchScreenVC: UIViewController {

    let animate = AnimateUI()
    
    @IBOutlet weak var logoImage: UIImageView!
    //@IBOutlet weak var flamingoLabel: UILabel!
    @IBOutlet weak var buttonNext: SetupButton!
    @IBOutlet weak var buttonLogIn: SetupButton!
    @IBOutlet weak var buttonRegistration: SetupButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = UserDefaults.standard.string(forKey: "namePerson")
        if user != nil{
            performSegue(withIdentifier: "StartApp", sender: nil) // переходим
        }
        setupElements()
        DispatchQueue.global(qos: .background).async { // подгружаем данные из FireBase, пока загружается анимация
            print("Start get data")
            FirebaseManager.getDataDicontsOfFirebase()
            FirebaseManager.getDataServicesOfFirebase()
            FirebaseManager.getDataMastersOfFirebase()
            FirebaseManager.getDataCategorysOfFirebase()
        }
        //cleatViewController() // делаем все объекты невидимыми(+ даективация кнопки)
        //animateElements() // анимация элементов UI
        
    }
    
    private func setupElements(){
        //buttonLogIn.layer.borderWidth = BorderWidth.borderWidth
        //buttonLogIn.layer.borderColor = ColorApp.greenComplete.cgColor
        buttonLogIn.tintColor = ColorApp.greenComplete
        //buttonLogIn.layer.cornerRadius = self.buttonLogIn.frame.size.width/7
        
        //buttonNext.layer.borderWidth = BorderWidth.borderWidth
        //buttonNext.layer.borderColor = ColorApp.white.cgColor
        buttonNext.tintColor = ColorApp.white
        //buttonNext.layer.cornerRadius = self.view.frame.size.width * 0.1
    }
    
    
    //private func()
    
    //MARK: Navigation Animate
    @IBAction func startView(_ sender: Any) {
        animate.nextViewController(viewController: self) // запускаем анимацию перехода на view
        performSegue(withIdentifier: "StartApp", sender: nil) // переходим 
    }
    
    // MARK: Clear View (alpha 0)
    private func cleatViewController(){
        logoImage.alpha = 0.0
        //flamingoLabel.alpha = 0.0
        buttonNext.alpha = 0.0
        //buttonNext.isUserInteractionEnabled = false
        buttonLogIn.alpha = 0.0
        //buttonLogIn.isUserInteractionEnabled = false
        buttonRegistration.alpha = 0.0
        //buttonRegistration.isUserInteractionEnabled = false
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

        


