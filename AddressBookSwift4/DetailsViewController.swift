//
//  DetailsViewController.swift
//  AddressBookSwift4
//
//  Created by Arnaud on 25/10/2017.
//  Copyright © 2017 Arnaud. All rights reserved.
//

import UIKit

protocol DetailsViewControllerDelegate: AnyObject {
    func reloadCList()

}

class DetailsViewController: UIViewController {
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    
    weak var delegate: DetailsViewControllerDelegate?
    var currentPerson: Person?
    
    func updateLabels() {
        guard let person = currentPerson else {
            return
        }
        firstNameLabel.text = person.firstName
        lastNameLabel.text = person.lastName
        guard let avatarURL = person.avatarURL else {
            return
        }
        contactImage.downloadImage(url: avatarURL)
        contactImage.contentMode = UIViewContentMode.scaleAspectFit
    }
    
    @objc func deleteContact() {
        let deleteAlertController = UIAlertController(title: "Delete Alert", message: "Are you sure you want to delete this contact ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            return
        }
        deleteAlertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let id = self.currentPerson?.id else {
                return
            }
            self.appDelegate().removeContactOnServer(serverId: Int(id))
            self.delegate?.reloadCList()
 
        }
        deleteAlertController.addAction(OKAction)
        
        self.present(deleteAlertController, animated: true) {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateLabels()
        let deleteContact = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.deleteContact))
        self.navigationItem.rightBarButtonItem = deleteContact
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
