//
//  PresentPhotoSalonVC.swift
//  Flamingo
//
//  Created by mac on 17/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class PresentPhotoSalonVC: UIViewController {

    let spacing = CGFloat(1)
    let array = [UIImage(named: "f39"), UIImage(named: "f40"),
                    UIImage(named: "f41"), UIImage(named: "f46"),
                    UIImage(named: "f47"), UIImage(named: "f49"),
                    UIImage(named: "f53"), UIImage(named: "f54"),
                    UIImage(named: "f56"), UIImage(named: "f80")]
    var arrayImageData = Array<Data>()
    var numberOfItemsPerRow:CGFloat = 1 // количество отображаемых картинок
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonSwap: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        exitButton.tintColor = ColorApp.redExit
        buttonSwap.tintColor = ColorApp.greenComplete
    }
    
    // меняем режим отображения
    @IBAction func actionReloadCV(_ sender: Any) {
        if numberOfItemsPerRow == 1{
            numberOfItemsPerRow = 4
            buttonSwap.setImage(UIImage(systemName: "square.grid.4x3.fill"), for: .normal)
            self.collectionView.reloadData()
        }else{
            numberOfItemsPerRow = 1
            buttonSwap.setImage(UIImage(systemName: "square"), for: .normal)
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func exitView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
    }
    
    
}

extension PresentPhotoSalonVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "CellPhotoSalon", for: indexPath) as! CustomCVCAlbum
        item.imageAlbum.image = array[indexPath.row]
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacingBetweenCells:CGFloat = 1
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        if let collection = self.collectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}
