//
//  SimpleNoteStorage.swift
//  TestRostelecom
//
//  Created by Савченко Максим Олегович on 2020. 10.27..
//  Copyright © 2020. Савченко Максим Олегович. All rights reserved.
//

import CoreData

final class SimpleNoteStorage {
    static let storage: SimpleNoteStorage = SimpleNoteStorage()
    
    private var simpleNoteIndexToIdDict: [Int:UUID] = [:]
    private var currentIndex: Int = 0

    private(set) var managedObjectContext: NSManagedObjectContext
    private var managedContextHasBeenSet: Bool = false
    
    private init() {
        managedObjectContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    }
    
    func setManagedContext(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.managedContextHasBeenSet = true
        let simpleNotes = SimpleNoteCoreDataHelper.readSimpleNotesFromCoreData(fromManagedObjectContext: self.managedObjectContext)
        currentIndex = SimpleNoteCoreDataHelper.count
        for (index, SimpleNote) in simpleNotes.enumerated() {
            simpleNoteIndexToIdDict[index] = SimpleNote.simpleNoteId
        }
    }
    
    func addSimpleNote(simpleNoteToBeAdded: SimpleNote) {
        if managedContextHasBeenSet {
           
            simpleNoteIndexToIdDict[currentIndex] = simpleNoteToBeAdded.simpleNoteId
            SimpleNoteCoreDataHelper.createSimpleNoteInCoreData(
                simpleNoteToBeCreated:          simpleNoteToBeAdded,
                intoManagedObjectContext: self.managedObjectContext)
        
            currentIndex += 1
        }
    }
    
    func removeSimpleNote(at: Int) {
        if managedContextHasBeenSet {
           
            if at < 0 || at > currentIndex-1 {
                return
            }
            
            let simpleNoteUUID = simpleNoteIndexToIdDict[at]
            SimpleNoteCoreDataHelper.deleteSimpleNoteFromCoreData(
                simpleNoteIdToBeDeleted:        simpleNoteUUID!,
                fromManagedObjectContext: self.managedObjectContext)
            
            if (at < currentIndex - 1) {
                
                for i in at ... currentIndex - 2 {
                    simpleNoteIndexToIdDict[i] = simpleNoteIndexToIdDict[i+1]
                }
            }
            
            simpleNoteIndexToIdDict.removeValue(forKey: currentIndex)
           
            currentIndex -= 1
        }
    }
    
    func readSimpleNote(at: Int) -> SimpleNote? {
        if managedContextHasBeenSet {
            
            if at < 0 || at > currentIndex-1 {
                
                return nil
            }
           
            let simpleNoteUUID = simpleNoteIndexToIdDict[at]
            let simpleNoteReadFromCoreData: SimpleNote?
            simpleNoteReadFromCoreData = SimpleNoteCoreDataHelper.readSimpleNoteFromCoreData(
                simpleNoteIdToBeRead:           simpleNoteUUID!,
                fromManagedObjectContext: self.managedObjectContext)
            return simpleNoteReadFromCoreData
        }
        return nil
    }
    
    func changeSimpleNote(simpleNoteToBeChanged: SimpleNote) {
        if managedContextHasBeenSet {
           
            var simpleNoteToBeChangedIndex : Int?
            simpleNoteIndexToIdDict.forEach { (index: Int, simpleNoteId: UUID) in
                if simpleNoteId == simpleNoteToBeChanged.simpleNoteId {
                    simpleNoteToBeChangedIndex = index
                    return
                }
            }
            if simpleNoteToBeChangedIndex != nil {
                SimpleNoteCoreDataHelper.changeSimpleNoteInCoreData(
                simpleNoteToBeChanged: simpleNoteToBeChanged,
                inManagedObjectContext: self.managedObjectContext)
            } else {
                
            }
        }
    }

    
    func count() -> Int {
        return SimpleNoteCoreDataHelper.count
    }
}
