//
//  ContactsTableViewController.swift
//  AddressBookSwift4
//
//  Created by Arnaud on 25/10/2017.
//  Copyright © 2017 Arnaud. All rights reserved.
//

import UIKit

class Person {
    var firstName: String
    var lastName: String
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension Person: Equatable {
    public static func ==(lhs: Person, rhs: Person) -> Bool {
        return (lhs.firstName == rhs.firstName) && (lhs.lastName == rhs.lastName)
    }
}

class ContactsTableViewController: UITableViewController {
    
    var persons = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Contacts"
        persons.append(Person(firstName: "Michel", lastName: "Durand"))
        persons.append(Person(firstName: "Marc", lastName: "Dupont"))
        persons.append(Person(firstName: "Marie", lastName: "Martin"))
        //self.tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactTableViewCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let addContact = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addContactPress))
        self.navigationItem.rightBarButtonItem = addContact
    }
    
    @objc func addContactPress() {
        let addViewController = AddViewController(nibName: nil, bundle: nil)
        addViewController.title = "Add User"
        addViewController.delegate = self
        
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController(nibName: nil, bundle: nil)
        detailsViewController.title = "Details"
        detailsViewController.firstName = persons[indexPath.row].firstName
        detailsViewController.lastName = persons[indexPath.row].lastName
        
        detailsViewController.delegate = self
        
        
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return persons.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath)

        // Configure the cell...

        if let contactCell = cell as? ContactTableViewCell {
            contactCell.nameLabel.text = persons[indexPath.row].firstName + " " + persons[indexPath.row].lastName
        }
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ContactsTableViewController: AddViewControllerDelegate {
    func addPersonName(firstName: String, lastName: String) {
        self.persons.append(Person(firstName: firstName, lastName: lastName))
        self.navigationController?.popViewController(animated: true)
        self.tableView.reloadData()
    }
}

extension ContactsTableViewController: DetailsViewControllerDelegate {
    func deleteContact(firstName: String, lastName: String) {
        let contactToDelete = Person(firstName: firstName, lastName: lastName)
        persons = persons.filter({$0 != contactToDelete})
        self.navigationController?.popViewController(animated: true)
        self.tableView.reloadData()
    }

}
