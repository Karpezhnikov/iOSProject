//
//  AnimateLaunchScreenVC.swift
//  Flamingo
//
//  Created by mac on 19/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

// ToDo: доделать анимацию, вынести всю анимацию в отдельную функцию и вызывать ее от туда 

import UIKit

class AnimateLaunchScreenVC: UIViewController {

    @IBOutlet weak var helloLebel: SetupLabel!
    @IBOutlet weak var flamingoLabel: UILabel!
    @IBOutlet weak var buttonNext: SetupButton!
    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImage.alpha = 0.0
        helloLebel.alpha = 0.0
        flamingoLabel.alpha = 0.0
        buttonNext.alpha = 0.0
        buttonNext.isUserInteractionEnabled = false
        animateLabelNameSalon()
        
    }
    

    @IBAction func startView(_ sender: Any) {
        //performSegue(withIdentifier: "StartApp", sender: nil)
        let transition = CATransition()

        transition.duration = 2.0
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(ViewController(), animated: false)
        performSegue(withIdentifier: "StartApp", sender: nil)
    }
    
    func animateLabelHello(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            UIView.animate(withDuration: 3.0, animations: { [weak self] in
                self!.logoImage.alpha = 1.0
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self!.buttonNext.isUserInteractionEnabled = true
            UIView.animate(withDuration: 2.0, animations: { [weak self] in
                self!.buttonNext.alpha = 1.0
            })
        }
    }
    
    func animateLabelNameSalon(){
        UIView.animate(withDuration: 3.0, animations: { [weak self] in
            self!.flamingoLabel.alpha = 1.0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            //Thread.sleep(forTimeInterval: 3)
            UIView.animate(withDuration: 3.0, animations: { [weak self] in
                self!.flamingoLabel.alpha = 0.0
            })
            self!.animateLabelHello()
        }
        
    }
    

}
