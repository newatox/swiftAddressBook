//
//  AppDelegate.swift
//  AddressBookSwift4
//
//  Created by Arnaud on 25/10/2017.
//  Copyright © 2017 Arnaud. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let sourceURL = "http://192.168.116.2:3000/persons"

    
    func updateDataFromServer() {
        let url = URL(string: sourceURL)!
        let task = URLSession.shared.dataTask(with:url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            let dictionnary = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            guard let jsonDict = dictionnary as? [[String : Any]] else {
                return
            }
            
            self.updateFromJsonData(json: jsonDict)
            
        }
        task.resume()
    }
    
    func updateFromJsonData(json: [[String : Any]]) {
        let sort = NSSortDescriptor(key: "id", ascending: true)
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        fetchRequest.sortDescriptors = [sort]
        
        let context = self.persistentContainer.viewContext
        
        
        let persons = try! context.fetch(fetchRequest)
        let personIds = persons.map({ (person) -> Int32 in
            return person.id
        })
        
        let serversId = json.map { (dict) -> Int in
            return dict["id"] as? Int ?? 0
        }
        //Delete data that is not on server
        for person in persons {
            if !serversId.contains(Int(person.id)) {
                context.delete(person)
            }
        }
        // Update or create
        for jsonPerson in json {
            let id = jsonPerson["id"] as? Int ?? 0
            if let index = personIds.index(of: Int32(id)) {
                persons[index].lastName = jsonPerson["lastname"] as? String ?? "ERROR"
                persons[index].firstName = jsonPerson["surname"] as? String ?? "ERROR"
                persons[index].avatarURL = jsonPerson["pictureUrl"] as? String
            } else {
                let person = Person(context: context)
                person.lastName = jsonPerson["lastname"] as? String
                person.firstName = jsonPerson["surname"] as? String
                person.avatarURL = jsonPerson["pictureUrl"] as? String
                person.id = Int32(id)
            }
        }
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
                print(error)
        }
    }

    func putContactOnServer(firstName: String, lastName: String, avatarURL: String) {
        let url = URL(string: sourceURL)!
        var request = URLRequest(url: url)
        let jsonPerson: [String : String] = ["lastname": lastName, "surname": firstName, "pictureUrl": avatarURL]
        let context = self.persistentContainer.viewContext
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonPerson, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
            guard let dict = jsonDict as? [String : Any] else {
                return
            }
            
            let person = Person(entity: Person.entity(), insertInto: context)
            person.lastName = dict["lastname"] as? String
            person.firstName = dict["surname"] as? String
            person.avatarURL = dict["pictureUrl"] as? String
            person.id = Int32(dict["id"] as? Int ?? 0)
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    func removeContactOnServer(serverId: Int) {
        let url = URL(string: sourceURL + "/\(serverId)")!
        var request = URLRequest(url: url)
        let context = self.persistentContainer.viewContext
        
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
            
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    return
                }
            }
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
 

        
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "AddressBookSwift4")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


extension UIViewController {
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

