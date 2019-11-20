//
//  AnimateLaunchScreenVC.swift
//  Flamingo
//
//  Created by mac on 19/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

// ToDo: доделать анимацию, вынести всю анимацию в отдельную функцию и вызывать ее от туда

import UIKit

class LaunchScreenVC: UIViewController {

    let animate = AnimateUI()
    
    @IBOutlet weak var helloLebel: SetupLabel!
    @IBOutlet weak var flamingoLabel: UILabel!
    @IBOutlet weak var buttonNext: SetupButton!
    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cleatViewController() // делаем все объекты невидимыми(+ даективация кнопки)
        animateLabelNameSalon()
        
    }
    
    @IBAction func startView(_ sender: Any) {
        animate.nextViewController(viewController: self) // запускаем анимацию перехода на view
        performSegue(withIdentifier: "StartApp", sender: nil) // перехлдим 
    }
    
    private func cleatViewController(){
        logoImage.alpha = 0.0
        helloLebel.alpha = 0.0
        flamingoLabel.alpha = 0.0
        buttonNext.alpha = 0.0
        buttonNext.isUserInteractionEnabled = false
    }
    
    private func animateLabelHello(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in // ждем 3 секунды
            self!.animate.imageAnimateAlfa(button: self!.logoImage, toAlfa: 1.0) // шаг 4 - появляется logoImage
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in // через 2 сек после запуска logoImage
            self!.buttonNext.isUserInteractionEnabled = true // активируем кнопку
            self!.animate.buttonAnimateAlfa(button: self!.buttonNext, toAlfa: 1.0) // шаг 5 - появляется кнопка войти
        }
    }
    
    private func animateLabelNameSalon(){
        animate.labelAnimateAlfa(button: flamingoLabel, toAlfa: 1.0) // шаг 1 - появляется название салона
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in // через 3 секунды
            self!.animate.labelAnimateAlfa(button: self!.flamingoLabel, toAlfa: 0.0)//шаг 2 - убирает название
            self!.animateLabelHello() // шаг 3 - рапускаем функцию появления приветствия
        }
    }
}




