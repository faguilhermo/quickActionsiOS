//
//  ContactTableViewCell.swift
//  quickActionsiOS
//
//  Created by Fabrício Guilhermo on 30/03/20.
//  Copyright © 2020 Fabrício Guilhermo. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var telephoneOutlet: UILabel!

    func cellConfig(_ contact: Contato) {
        nameOutlet.text = contact.nome
        telephoneOutlet.text = contact.telefone
        addressOutlet.text = contact.endereco
        imageOutlet.layer.cornerRadius = imageOutlet.frame.height/2
        imageOutlet.layer.masksToBounds = true
        if let image = contact.photo as? UIImage {
            imageOutlet.image = image
        }
    }
    
}
