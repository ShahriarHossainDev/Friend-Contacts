//
//  HomeTableViewCell.swift
//  Friend Contacts
//
//  Created by Shishir_Mac on 27/3/23.
//

import UIKit
import Contacts

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView! {
        didSet {
            photoImageView.layer.masksToBounds = true
            photoImageView.layer.cornerRadius = 22.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var friend : Friend? {
        didSet {
            configureCell()
        }
    }
    
    private func configureCell() {
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        guard let friend = friend,
              let name = formatter.string(from: friend.contactValue) else { return }
        nameLabel.text = name
        emailLabel.text = friend.workEmail
        photoImageView.image = UIImage(named: "PlaceholderProfilePic")
    }
    
}
