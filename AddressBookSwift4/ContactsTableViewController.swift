//
//  ContactsTableViewController.swift
//  AddressBookSwift4
//
//  Created by Arnaud on 25/10/2017.
//  Copyright © 2017 Arnaud. All rights reserved.
//

import UIKit
import CoreData

class ContactsTableViewController: UITableViewController {
    //var persons = [Person]()
    var resultController: NSFetchedResultsController<Person>?
    
    /*
    func reloadDataFromDataBase() {
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        let sortFirstName = NSSortDescriptor(key: "firstName", ascending: true)
        let sortLastName = NSSortDescriptor(key: "lastName", ascending: true)
        fetchRequest.sortDescriptors = [sortFirstName, sortLastName]
        
        let context = self.appDelegate().persistentContainer.viewContext
        guard let personsList = try? context.fetch(fetchRequest) else {
            return
        }
        persons = personsList
        self.tableView.reloadData()
    }
    */
    
    func addFromPlist() {
        //Import names from plist
        let namesPlist = Bundle.main.path(forResource: "names.plist", ofType: nil)
        if let namesPath = namesPlist {
            let url = URL(fileURLWithPath: namesPath)
            let dataArray  = NSArray(contentsOf: url)
            
            for dict in dataArray! {
                if let dictionnary = dict as? [String: String] {
                    let context = appDelegate().persistentContainer.viewContext
                    let person = Person(entity: Person.entity(), insertInto: context)
                    person.firstName = dictionnary["name"]
                    person.lastName = dictionnary["lastname"]
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                //reloadDataFromDataBase()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Welcome message
        if(UserDefaults.standard.isFirstLaunch()) {
            let welcomeAlertController = UIAlertController(title: "Welcome", message: "This is your first time here. Welcome!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
                return
            }
            welcomeAlertController.addAction(OKAction)
            self.present(welcomeAlertController, animated: true) {
            }
        }
        UserDefaults.standard.userSawWelcomeMessage()
        
        
        
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        let sortFirstName = NSSortDescriptor(key: "firstName", ascending: true)
        let sortLastName = NSSortDescriptor(key: "lastName", ascending: true)
        fetchRequest.sortDescriptors = [sortFirstName, sortLastName]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.appDelegate().persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        
        frc.delegate = self
        
        try? frc.performFetch()
        
        self.resultController = frc
        
        //reloadDataFromDataBase()
        self.title = "Contacts"
        
        

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
        //detailsViewController.currentPerson = persons[indexPath.row]
        guard let object = self.resultController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        detailsViewController.currentPerson = object

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
        if let frc = self.resultController {
            return frc.sections!.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sections = self.resultController?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath)

        // Configure the cell...
        guard let object = self.resultController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        if let contactCell = cell as? ContactTableViewCell {
            guard let firstName = object.firstName, let lastName = object.lastName else {
                return cell
            }
            contactCell.nameLabel.text = firstName + " " + lastName
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
    func reloadContactList() {
        self.navigationController?.popViewController(animated: true)
        //reloadDataFromDataBase()
    }
}

extension ContactsTableViewController: DetailsViewControllerDelegate {
    func reloadCList() {
        self.navigationController?.popViewController(animated: true)
        //reloadDataFromDataBase()
    }
}

extension ContactsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }

}
