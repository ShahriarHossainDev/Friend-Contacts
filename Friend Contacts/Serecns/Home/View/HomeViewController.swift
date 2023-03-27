//
//  HomeViewController.swift
//  Friend Contacts
//
//  Created by Shishir_Mac on 27/3/23.
//

import UIKit
import ContactsUI
import MessageUI

class HomeViewController: UIViewController {
    
    var friendsList = [Friend]()
    
    private let cellIdentifier: String = "homeCell"
    
    private var selectedContacts: [CNContact] = []
    
    @IBOutlet weak var noContactsLabel: UILabel!
    @IBOutlet weak var contactsTabelView: UITableView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var sendMailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Friend Contacts"
        
        contactsTabelView.delegate = self
        contactsTabelView.dataSource = self
        
        buttonView.layer.cornerRadius = 5
        buttonView.dropShadow()
        
        sendMailButton.layer.cornerRadius = 5
        
        self.contactsTabelView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        // Do any additional setup after loading the view.
        
        if friendsList.count != 0 {
            noContactsLabel.isHidden = true
        } else {
            noContactsLabel.isHidden = false
        }
    }
    
    
    // MARK: - IBAction
    @IBAction func addFriendsBarButtonAction(_ sender: UIBarButtonItem) {
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        
        contactPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
        present(contactPicker, animated: true)
    }
    
    @IBAction func sendMailButtonAction(_ sender: UIButton) {
        guard !selectedContacts.isEmpty else {
            let alert = UIAlertController(title: "No Contacts Selected", message: "Please select at least one contact to send mail.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(selectedContacts.compactMap { $0.emailAddresses.first?.value as String? })
        mailComposerVC.setSubject("Hello")
        mailComposerVC.setMessageBody("This is a random message.", isHTML: false)
        present(mailComposerVC, animated: true)
    }
    
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? HomeTableViewCell {
            
            if friendsList.count != 0 {
                noContactsLabel.isHidden = true
            } else {
                noContactsLabel.isHidden = false
            }
            
            let friend = friendsList[indexPath.row]
            cell.friend = friend
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let friend = friendsList[indexPath.row]
        let contact = friend.contactValue
        
        let contactViewController = CNContactViewController(forUnknownContact: contact)
        contactViewController.hidesBottomBarWhenPushed = true
        contactViewController.allowsEditing = false
        contactViewController.allowsActions = false
        
        selectedContacts = [contact]
        //navigationController?.pushViewController(contactViewController, animated: true)
    }
    
}

//MARK: - CNContactPickerDelegate
extension HomeViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        let newFriends = contacts.compactMap { Friend(contact: $0) }
        for friend in newFriends {
            if !friendsList.contains(friend) {
                friendsList.append(friend)
            }
        }
        contactsTabelView.reloadData()
    }
}


extension HomeViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
