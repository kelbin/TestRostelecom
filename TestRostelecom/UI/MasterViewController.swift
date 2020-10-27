//
//  MasterViewController.swift
//  TestRostelecom
//
//  Created by Савченко Максим Олегович on 2020. 10.27..
//  Copyright © 2020. Савченко Максим Олегович. All rights reserved.
//

import UIKit

final class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            let alert = UIAlertController(
                title: "Нету аппделегата",
                message: "Тест",
                preferredStyle: .alert)
            
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default))
            
            self.present(alert, animated: true)

            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        SimpleNoteStorage.storage.setManagedContext(managedObjectContext: managedContext)
        
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "showCreateSimpleNoteSegue", sender: self)
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row]
                let object = SimpleNoteStorage.storage.readSimpleNote(at: indexPath.row)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SimpleNoteStorage.storage.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SimpleNoteUITableViewCell

        if let object = SimpleNoteStorage.storage.readSimpleNote(at: indexPath.row) {
        cell.simpleNoteTitleLabel!.text = object.simpleNoteTitle
        cell.simpleNoteTextLabel!.text = object.simpleNoteText
            cell.simpleNoteDateLabel!.text = SimpleNoteDateHelper.convertDate(date: Date.init(seconds: object.simpleNoteTimeStamp))
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            SimpleNoteStorage.storage.removeSimpleNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


}

