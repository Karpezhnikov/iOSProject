//
//  AddNewDreamVC.swift
//  DreamsComeTrue
//
//  Created by Алексей Карпежников on 22/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class AddNewDreamVC: UIViewController {

    
    @IBOutlet weak var photoNewDream: UIImageView!
    @IBOutlet weak var saleTextField: UITextField!
    @IBOutlet weak var dremTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup imageView
        //photoNewDream.layer.cornerRadius = 5
        
        // setup descTextView
        descTextView.text = ""
        descTextView.layer.borderWidth = 1
        descTextView.layer.borderColor = saleTextField.layer.borderColor
        
        
    }
    
    @IBAction func photoNewDream(_ sender: Any) {
        imagePicker()
    }
    
    @IBAction func addNewDream(_ sender: Any) {
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

// MARK: ext. Work with image picker
extension AddNewDreamVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // создаем вызов алерта(высплывающего окна) для выбора способа загрузки
    func imagePicker(){
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Камера", style: .default) { (_) in
            self.chooseImagePicker(source: .camera)
        }
        let photo =  UIAlertAction(title: "Фото", style: .default) { (_) in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let cancel =  UIAlertAction(title: "Отмена", style: .cancel) { (_) in
                   // TODO: chooseImagePicker
        }
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    // определяем как и откуда грузить фото
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){ // если есть доступ к ресурсу
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true // позволяет редактировать из-е перед вставкой
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    // получаем фото
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photoNewDream.image = info[.editedImage] as? UIImage
        photoNewDream.contentMode = .scaleAspectFill // растягиваем из-е
        photoNewDream.clipsToBounds = true // обрезаем по краям
        dismiss(animated: true) // закрываем imagePicker
    }
}
