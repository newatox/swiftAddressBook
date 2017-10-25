//
//  DetailsViewController.swift
//  AddressBookSwift4
//
//  Created by Arnaud on 25/10/2017.
//  Copyright © 2017 Arnaud. All rights reserved.
//

import UIKit

protocol DetailsViewControllerDelegate: AnyObject {
    func deleteContact(firstName: String, lastName: String)

}

class DetailsViewController: UIViewController {
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    weak var delegate: DetailsViewControllerDelegate?
    var firstName: String?
    var lastName: String?
    
    func updateLabels() {
        firstNameLabel.text = firstName
        lastNameLabel.text = lastName
    }
    
    @objc func deleteContact() {
        guard let firstName = self.firstName, let lastName = self.lastName else {
            return
        }
        let deleteAlertController = UIAlertController(title: "Delete Alert", message: "Are you sure you want to delete this contact ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            return
        }
        deleteAlertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.delegate?.deleteContact(firstName: firstName, lastName: lastName)
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
