//
//  CollectionViewAlbum.swift
//  
//
//  Created by mac on 20/01/2020.
//

import UIKit

class CollectionViewAlbum: UICollectionView {

    let spacing = CGFloat(0)
    
    let arrayPhotoDesign = [UIImage(named: "f39"), UIImage(named: "f40"),
    UIImage(named: "f41"), UIImage(named: "f46"),
    UIImage(named: "f47"), UIImage(named: "f49"),
    UIImage(named: "f53"), UIImage(named: "f54"),
    UIImage(named: "f56"), UIImage(named: "f80")]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .horizontal
        self.collectionViewLayout = layout

        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPhotoDesign.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "CellDesign", for: indexPath) as! DesignCVC
        collectionView.register(UICollectionView.self, forCellWithReuseIdentifier: "CellDesign")
        item.image.image = arrayPhotoDesign[indexPath.row]
        print(indexPath.row)
        return item
            
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightItem = self.frame.size.height - 2
        return CGSize(width: heightItem, height: heightItem)
        
    }

}
