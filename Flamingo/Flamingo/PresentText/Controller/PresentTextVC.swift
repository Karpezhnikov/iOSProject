//
//  PresentTextVC.swift
//  Flamingo
//
//  Created by mac on 06.02.2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit

class PresentTextVC: UIViewController {

    var textData = ""
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.isUserInteractionEnabled = false
        textView.text = textData
        
        button.addTarget(self, action: #selector(self.exitVC), for: .touchUpInside)
        button.setupBackButton()
    }
    
    @objc func exitVC( sender : UIButton ) {
        self.dismiss(animated: true, completion: nil)
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
