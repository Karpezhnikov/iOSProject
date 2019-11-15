//
//  EditOnServiceViewController.swift
//  Flamingo
//
//  Created by mac on 15/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit


// ToDo: доделать дизайн + добавить поля с телефоном и именем
class EditOnServiceViewController: UIViewController {

    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var buttonClose: SetupButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        smallView.layer.cornerRadius = buttonClose.frame.size.width/2
        // Do any additional setup after loading the view.
    }
    

    @IBAction func closeEditOnServiceController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
