//
//  StorageManager.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 18.03.2024.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    let context: NSManagedObjectContext
    private let container: NSPersistentContainer
    private let containerName: String = "ExpenseTrackerOBRIO"
    
    var isPassedFirstSession: Bool {
        get { UserDefaults.standard.bool(forKey: "isPassedFirstSession") }
        set { UserDefaults.standard.set(newValue, forKey: "isPassedFirstSession") }
    }
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        context = container.viewContext
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        if !self.isPassedFirstSession {
            let newBalance = Balance(context: self.context)
            newBalance.balance = Double(0)
            
            self.saveContext()
            self.isPassedFirstSession = true
        }
    }
    
    func fetchBalance() -> Balance? {
        var balance: Balance?
        let request = NSFetchRequest<Balance>(entityName: "Balance")
        do {
            balance = try self.context.fetch(request).first
        } catch let error {
            print("Error fetching saved data: \(error)")
        }
        return balance
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addBitcoins(amount: Double) {
        let balance = fetchBalance()
        
        if let balance = balance {
            balance.balance += amount
            self.saveContext()
        }
    }
}
