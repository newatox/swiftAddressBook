//
//  AddViewController.swift
//  AddressBookSwift4
//
//  Created by Arnaud on 25/10/2017.
//  Copyright © 2017 Arnaud. All rights reserved.
//

import UIKit

protocol AddViewControllerDelegate: AnyObject {
    func addPersonName(firstName: String, lastName: String)
}

class AddViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    weak var delegate: AddViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addContact = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.addContactToList))
        self.navigationItem.rightBarButtonItem = addContact

        // Do any additional setup after loading the view.
    }
    
    @objc func addContactToList() {
        guard let newContactFirstName = firstNameTextField?.text, let newContactLastName = lastNameTextField?.text else {
            return
        }
        
        self.delegate?.addPersonName(firstName: newContactFirstName, lastName: newContactLastName)
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
