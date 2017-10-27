//
//  AddViewController.swift
//  AddressBookSwift4
//
//  Created by Arnaud on 25/10/2017.
//  Copyright © 2017 Arnaud. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var completionProgressBar: UIProgressView!
    

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
        if newContactLastName == "" && newContactFirstName == "" {
            return
        }
        
        self.completionProgressBar.alpha = 1
        DispatchQueue.global(qos: .userInitiated).async {
            for _ in 0..<100 {
                DispatchQueue.main.async {
                    self.completionProgressBar.setProgress(self.completionProgressBar.progress + 0.01, animated: true)
                }
                Thread.sleep(forTimeInterval: 0.01)
            }
            
            DispatchQueue.main.async {
                self.appDelegate().putContactOnServer(firstName: newContactFirstName, lastName: newContactLastName, avatarURL: "https://www.wanimo.com/veterinaire/images/articles/chat/chaton-diarrhee.jpg")
                self.navigationController?.popViewController(animated: true)
            }
        }
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
