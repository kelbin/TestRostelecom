//
//  SimpleNoteCoreDataHelper.swift
//  TestRostelecom
//
//  Created by Савченко Максим Олегович on 2020. 01. 25..
//  Copyright © 2020. Савченко Максим Олегович. All rights reserved.
//

import Foundation
import CoreData

final class SimpleNoteCoreDataHelper {
    
    private(set) static var count: Int = 0
    
    static func createSimpleNoteInCoreData(simpleNoteToBeCreated: SimpleNote, intoManagedObjectContext:NSManagedObjectContext) {
        
        let simpleNoteEntity = NSEntityDescription.entity(
            forEntityName: "Note",
            in:            intoManagedObjectContext)!
        
        let newSimpleNoteToBeCreated = NSManagedObject(
            entity:     simpleNoteEntity,
            insertInto: intoManagedObjectContext)

        newSimpleNoteToBeCreated.setValue(
            simpleNoteToBeCreated.simpleNoteId,
            forKey: "noteId")
        
        newSimpleNoteToBeCreated.setValue(
            simpleNoteToBeCreated.simpleNoteTitle,
            forKey: "noteTitle")
        
        newSimpleNoteToBeCreated.setValue(
            simpleNoteToBeCreated.simpleNoteText,
            forKey: "noteText")
        
        newSimpleNoteToBeCreated.setValue(
            simpleNoteToBeCreated.simpleNoteTimeStamp,
            forKey: "noteTimeStamp")
        
        do {
            try intoManagedObjectContext.save()
            count += 1
        } catch let error as NSError {
            
            print("\(error), \(error.userInfo)")
        }
    }
    
    static func changeSimpleNoteInCoreData(
        simpleNoteToBeChanged: SimpleNote,
        inManagedObjectContext: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        let simpleNoteIdPredicate = NSPredicate(format: "noteId = %@", simpleNoteToBeChanged.simpleNoteId as CVarArg)
        
        fetchRequest.predicate = simpleNoteIdPredicate
        
        do {
            let fetchedSimpleNotesFromCoreData = try inManagedObjectContext.fetch(fetchRequest)
            let simpleNoteManagedObjectToBeChanged = fetchedSimpleNotesFromCoreData[0] as! NSManagedObject
            
            simpleNoteManagedObjectToBeChanged.setValue(
                simpleNoteToBeChanged.simpleNoteTitle,
                forKey: "noteTitle")

            simpleNoteManagedObjectToBeChanged.setValue(
                simpleNoteToBeChanged.simpleNoteText,
                forKey: "noteText")

            simpleNoteManagedObjectToBeChanged.setValue(
                simpleNoteToBeChanged.simpleNoteTimeStamp,
                forKey: "noteTimeStamp")

            try inManagedObjectContext.save()

        } catch let error as NSError {
        
            print("\(error), \(error.userInfo)")
        }
    }
    
    static func readSimpleNotesFromCoreData(fromManagedObjectContext: NSManagedObjectContext) -> [SimpleNote] {

        var returnedSimpleNotes = [SimpleNote]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetchRequest.predicate = nil
        
        do {
            let fetchedSimpleNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            fetchedSimpleNotesFromCoreData.forEach { (fetchRequestResult) in
                let simpleNoteManagedObjectRead = fetchRequestResult as! NSManagedObject
                returnedSimpleNotes.append(SimpleNote.init(
                    simpleNoteId:        simpleNoteManagedObjectRead.value(forKey: "noteId")        as! UUID,
                    simpleNoteTitle:     simpleNoteManagedObjectRead.value(forKey: "noteTitle")     as! String,
                    simpleNoteText:      simpleNoteManagedObjectRead.value(forKey: "noteText")      as! String,
                    simpleNoteTimeStamp: simpleNoteManagedObjectRead.value(forKey: "noteTimeStamp") as! Int64))
            }
        } catch let error as NSError {
            
            print(" \(error), \(error.userInfo)")
        }
        
       
        self.count = returnedSimpleNotes.count
        
        return returnedSimpleNotes
    }
    
    static func readSimpleNoteFromCoreData(
        simpleNoteIdToBeRead:           UUID,
        fromManagedObjectContext: NSManagedObjectContext) -> SimpleNote? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        let simpleNoteIdPredicate = NSPredicate(format: "noteId = %@", simpleNoteIdToBeRead as CVarArg)
        
        fetchRequest.predicate = simpleNoteIdPredicate
        
        do {
            let fetchedSimpleNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            let simpleNoteManagedObjectToBeRead = fetchedSimpleNotesFromCoreData[0] as! NSManagedObject
            return SimpleNote.init(
                simpleNoteId:        simpleNoteManagedObjectToBeRead.value(forKey: "noteId")        as! UUID,
                simpleNoteTitle:     simpleNoteManagedObjectToBeRead.value(forKey: "noteTitle")     as! String,
                simpleNoteText:      simpleNoteManagedObjectToBeRead.value(forKey: "noteText")      as! String,
                simpleNoteTimeStamp: simpleNoteManagedObjectToBeRead.value(forKey: "noteTimeStamp") as! Int64)
        } catch let error as NSError {
            
            print(" \(error), \(error.userInfo)")
            return nil
        }
    }

    static func deleteSimpleNoteFromCoreData(
        simpleNoteIdToBeDeleted:        UUID,
        fromManagedObjectContext: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        let simpleNoteIdAsCVarArg: CVarArg = simpleNoteIdToBeDeleted as CVarArg
        let simpleNoteIdPredicate = NSPredicate(format: "noteId == %@", simpleNoteIdAsCVarArg)
        
        fetchRequest.predicate = simpleNoteIdPredicate
        
        do {
            let fetchedSimpleNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            let SimpleNoteManagedObjectToBeDeleted = fetchedSimpleNotesFromCoreData[0] as! NSManagedObject
            fromManagedObjectContext.delete(SimpleNoteManagedObjectToBeDeleted)
            
            do {
                try fromManagedObjectContext.save()
                self.count -= 1
            } catch let error as NSError {
                
                print("\(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            
            print("\(error), \(error.userInfo)")
        }
        
    }

}
