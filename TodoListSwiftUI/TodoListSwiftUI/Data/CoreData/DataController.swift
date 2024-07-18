//
//  DataController.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/08.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    static let shared = DataController()
    
    private var persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Todo")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }

}

