//
//  LaunchVC.swift
//  Flamingo
//
//  Created by mac on 16/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {

    let animate = AnimateUI()
    
    @IBOutlet weak var imageLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updataData()
        imageLogo.alpha = 0
        //imageLogo.backgroundColor = 
        segueFirst()
    }
    
    

    private func segueFirst(){
        self.animate.animateAlpha(element: self.imageLogo, toAlpha: 1.0, animateRunTime: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self!.animate.animateAlpha(element: self!.imageLogo, toAlpha: 0.0, animateRunTime: 1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            let firstLogin = UserDefaults.standard.bool(forKey: "firstLogin")
            if firstLogin{
                self!.performSegue(withIdentifier: "login", sender: nil) // переходим
            }else{
                self!.checkFirstLogin()
                self!.performSegue(withIdentifier: "firstLogin", sender: nil) // переходим
            }
        }
        
    }
    
    private func checkFirstLogin(){
        let firstLogin = UserDefaults.standard.bool(forKey: "firstLogin")
        if !firstLogin{
            UserDefaults.standard.set(true, forKey: "firstLogin")
        }
    }
    
    private func updataData(){
        DispatchQueue.global(qos: .userInteractive).async { // подгружаем данные из FireBase, пока загружается анимация
            print("Start get data")
            FirebaseManager.getDataDicontsOfFirebase()
            FirebaseManager.getDataServicesOfFirebase()
            FirebaseManager.getDataMastersOfFirebase()
            FirebaseManager.getDataCategorysOfFirebase()
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
