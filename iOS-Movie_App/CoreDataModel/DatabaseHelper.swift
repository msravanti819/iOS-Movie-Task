//
//  DatabaseHelper.swift
//  iOS-Movie_App
//
//  Created by Sravanti on 10/12/20.
//

import Foundation
import CoreData
import  UIKit
class DatabaseHelper {
    
    private init(){}
    static let sharedInstance = DatabaseHelper()
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    //MARK: - Create the Data
    func save(object: String?) {
        guard let movieSearch = NSEntityDescription.insertNewObject(forEntityName: "RecentSearch", into: context) as? RecentSearch else {return}
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        movieSearch.item = object
        do {
            try context.save()
        }catch {
            print("Not Saved")
        }
    }
//MARK: - Read the Data
    func load(completion: @escaping ([RecentSearch]) -> Void) {
        let request: NSFetchRequest<RecentSearch> = RecentSearch.fetchRequest()
        do {
            let temp = try context.fetch(request)
            completion(temp)
        }catch {
            //print(error)
        }
    }
}
