//
//  ImagePicker.swift
//  quickActionsiOS
//
//  Created by Fabrício Guilhermo on 30/03/20.
//  Copyright © 2020 Fabrício Guilhermo. All rights reserved.
//

import UIKit

enum OptionsPhoto {
    case camera
    case library
}

protocol ImagePickerSelectedImage {
    func imagePickerSelectedImage(_ photo: UIImage)
}

class ImagePicker: NSObject, UIImagePickerControllerDelegate {

    // MARK: - Variables
    var delegate: ImagePickerSelectedImage?

    // MARK: - Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        delegate?.imagePickerSelectedImage(photo)
        picker.dismiss(animated: true, completion: nil)
    }

    func optionsPhoto(completion: @escaping(_ option: OptionsPhoto) -> Void) -> UIAlertController {
        let menu = UIAlertController(title: "Atenção", message: "Para prosseguir, por favor, escolha uma das opções abaixo", preferredStyle: .actionSheet)

        let camera = UIAlertAction(title: "Tirar foto", style: .default) { (cameraAction) in
            completion(.camera)
        }
        menu.addAction(camera)

        let library = UIAlertAction(title: "Pegar foto da galeria", style: .default) { (libraryAction) in
            completion(.library)
        }
        menu.addAction(library)

        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        menu.addAction(cancel)

        return menu
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
