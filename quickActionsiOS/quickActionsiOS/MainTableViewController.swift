//
//  MainTableViewController.swift
//  quickActionsiOS
//
//  Created by Fabrício Guilhermo on 30/03/20.
//  Copyright © 2020 Fabrício Guilhermo. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {

    // MARK: - Variables
    var resultsMenager: NSFetchedResultsController<Contato>?
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    var contactToEdit: AddContactViewController?
    var message = Message()

    override func viewDidLoad() {
        super.viewDidLoad()
        getContact()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            contactToEdit = segue.destination as? AddContactViewController
        }
    }

    private func getContact() {
        let contactRequest: NSFetchRequest<Contato> = Contato.fetchRequest()
        let order = NSSortDescriptor(key: "nome", ascending: true)
        contactRequest.sortDescriptors = [order]

        resultsMenager = NSFetchedResultsController(fetchRequest: contactRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        resultsMenager?.delegate = self

        do {
            try resultsMenager?.performFetch()
        } catch {
            // tratar
        }
    }

    @objc private func openActionSheet(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            guard let selectedContact = resultsMenager?.fetchedObjects?[(longPress.view?.tag)!] else { return }
            let menu = OptionsMenuContacts().optionsMenuContactsSetup { (options) in
                switch options {
                case .message:
                    guard let phoneNumber = selectedContact.telefone else { return }
                    if let messageComponent = self.message.smsConfig(send: phoneNumber) {
                        messageComponent.messageComposeDelegate = self.message
                        self.present(messageComponent, animated: true, completion: nil)
                    }
                    break
                case .call:
                    guard let phoneNumber = selectedContact.telefone else { return }
                    if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        // tratar erro
                    }
                    break
                case .waze:
                    guard let url = URL(string: "waze://") else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        guard let address = selectedContact.endereco else { return }
                        Location().convertAddressToCoordinates(address) { (foundLocalization) in
                            let latitude = String(describing: foundLocalization.location!.coordinate.latitude)
                            let longitude = String(describing: foundLocalization.location!.coordinate.longitude)
                            let url: String = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
                            guard let wazeUrlToAddress = URL(string: url) else { return }
                            UIApplication.shared.open(wazeUrlToAddress, options: [:], completionHandler: nil)
                        }
                    } else {
                        // treat error showing an alert, for exemple.
                        print("Waze does not exists on this device")
                    }
                    break
                }
            }
            self.present(menu, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contactList = resultsMenager?.fetchedObjects?.count else { return 0 }
        return  contactList
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(openActionSheet))
        guard let contact = resultsMenager?.fetchedObjects?[indexPath.row] else { return cell }

        cell.cellConfig(contact)
        cell.addGestureRecognizer(longPress)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedContact = resultsMenager?.fetchedObjects![indexPath.row] else { return }
        contactToEdit?.contact = selectedContact
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let selectedContact = resultsMenager?.fetchedObjects![indexPath.row] else { return }
            context.delete(selectedContact)
            do {
                try context.save()
            } catch {
                // tratar
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - Extensions
extension MainTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
            break
        default:
            tableView.reloadData()
        }
    }
}
