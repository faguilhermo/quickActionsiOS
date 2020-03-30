//
//  Message.swift
//  LigacoesMensagensNativo
//
//  Created by Fabrício Guilhermo on 25/03/20.
//  Copyright © 2020 Fabrício Guilhermo. All rights reserved.
//

import MessageUI

final class Message: NSObject {
    /// Creates a message component to be called.
    /// - Parameter sms: the phone number to send the message
    func smsConfig(send sms: String) -> MFMessageComposeViewController? {
        if MFMessageComposeViewController.canSendText() {
            let messageComponent = MFMessageComposeViewController()
            messageComponent.recipients = [sms]
            messageComponent.messageComposeDelegate = self

            return messageComponent
        } else {
            return nil
        }
    }
}

extension Message: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        // dismiss the message component
        controller.dismiss(animated: true, completion: nil)
    }
}
