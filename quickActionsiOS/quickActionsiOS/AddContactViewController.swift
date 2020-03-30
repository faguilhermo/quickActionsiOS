//
//  ViewController.swift
//  quickActionsiOS
//
//  Created by Fabrício Guilhermo on 30/03/20.
//  Copyright © 2020 Fabrício Guilhermo. All rights reserved.
//

import UIKit
import CoreData

class AddContactViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var addPhotoButtonOutlet: UIButton!
    @IBOutlet weak var nameTextFieldOutlet: UITextField!
    @IBOutlet weak var telephoneTextFieldOutlet: UITextField!
    @IBOutlet weak var addressTextFieldOutlet: UITextField!

    // MARK: - Constants
    let imagePicker = ImagePicker()
    var contact: Contato?

    // MARK: - Variables
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if imageOutlet.image != nil {
            addPhotoButtonOutlet.isHidden = true
        }
    }

    // MARK: - Functions
    private func setup() {
        imagePicker.delegate = self
        guard let selectedContact = contact else { return }
        nameTextFieldOutlet.text = selectedContact.nome
        telephoneTextFieldOutlet.text = selectedContact.telefone
        addressTextFieldOutlet.text = selectedContact.endereco
        imageOutlet.image = selectedContact.photo as? UIImage
    }

    private func showMultimedia(_ option: OptionsPhoto) {
        let multimedia = UIImagePickerController()
        multimedia.delegate = imagePicker

        if option == .camera && UIImagePickerController.isSourceTypeAvailable(.camera) {
            multimedia.sourceType = .camera
        } else {
            multimedia.sourceType = .photoLibrary
        }
        addPhotoButtonOutlet.isHidden = true
        self.present(multimedia, animated: true, completion: nil)
    }

    // MARK: - Actions
    @IBAction func addPhotoButtonAction(_ sender: UIButton) {
        let menu = imagePicker.optionsPhoto { [weak self] (option) in
            guard let strongSelf = self else { return }
            strongSelf.showMultimedia(option)
        }

        present(menu, animated: true, completion: nil)
    }

    @IBAction func saveContactButtonAction(_ sender: UIBarButtonItem) {
        if contact == nil {
            contact = Contato(context: context)
        }
        contact?.nome = nameTextFieldOutlet.text
        contact?.telefone = telephoneTextFieldOutlet.text
        contact?.endereco = addressTextFieldOutlet.text
        contact?.photo = imageOutlet.image
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            // tratar
        }
    }
}

// MARK: - Extension
extension AddContactViewController: ImagePickerSelectedImage {
    func imagePickerSelectedImage(_ photo: UIImage) {
        imageOutlet.image = photo
    }
}

