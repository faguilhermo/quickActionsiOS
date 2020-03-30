//
//  OptionsMenuContacts.swift
//  quickActionsiOS
//
//  Created by Fabrício Guilhermo on 30/03/20.
//  Copyright © 2020 Fabrício Guilhermo. All rights reserved.
//

import UIKit

enum OptionsMenuActionSheet {
    case message
    case call
    case waze
}

class OptionsMenuContacts: NSObject {

    func optionsMenuContactsSetup(completion: @escaping(_ option: OptionsMenuActionSheet) -> Void) -> UIAlertController {
        let menu = UIAlertController(title: "Opções", message: "Por favor, selecione uma das opções baixo", preferredStyle: .actionSheet)

        let message = UIAlertAction(title: "Enviar mensagem", style: .default) { (messageAction) in
            completion(.message)
        }
        menu.addAction(message)

        let call = UIAlertAction(title: "Fazer ligação", style: .default) { (callAction) in
            completion(.call)
        }
        menu.addAction(call)

        let waze = UIAlertAction(title: "Traçar rota no Waze", style: .default) { (wazeAction) in
            completion(.waze)
        }
        menu.addAction(waze)

        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        menu.addAction(cancel)

        return menu
    }
}
