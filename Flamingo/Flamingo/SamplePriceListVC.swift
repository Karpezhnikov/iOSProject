//
//  SamplePriceListVC.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 25/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class SamplePriceListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var priceList = StractSamplePriceList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("asdaasdss", priceList.humanMale)
        
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceList.samplePriceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTVCell
        if priceList.samplePriceList.count == 0 {
            // todo: должен вернуться массив с всем прайсом
        }
        //cell.textLabel?.text = priceList.samplePriceList[indexPath.row]
        cell.typeOfService.text = priceList.samplePriceList[indexPath.row]
        
        return cell
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
