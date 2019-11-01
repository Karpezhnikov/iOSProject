//
//  DetailServiceVC.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 31/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class DetailServiceVC: UIViewController {

    var service = Service()
    
    @IBOutlet weak var nameDeteilService: UILabel!
    @IBOutlet weak var imageService: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameDeteilService.text = service.nameService
        // Do any additional setup after loading the view.
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
