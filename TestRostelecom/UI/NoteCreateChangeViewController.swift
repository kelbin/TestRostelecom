//
//  SimpleNoteCreateChangeViewController.swift
//  TestRostelecom
//
//  Created by Савченко Максим Олегович on 2020. 01. 22..
//  Copyright © 2020. Савченко Максим Олегович. All rights reserved.
//

import UIKit

final class SimpleNoteCreateChangeViewController : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var simpleNoteTitleTextField: UITextField!
    @IBOutlet weak var simpleNoteTextTextView: UITextView!
    @IBOutlet weak var simpleNoteDoneButton: UIButton!
    @IBOutlet weak var simpleNoteDateLabel: UILabel!
    
    private let simpleNoteCreationTimeStamp : Int64 = Date().toSeconds()
    private(set) var changingSimpleNote: SimpleNote?

    @IBAction func noteTitleChanged(_ sender: UITextField, forEvent event: UIEvent) {
        if self.changingSimpleNote != nil {
            
            simpleNoteDoneButton.isEnabled = true
        } else {
            
            if ( sender.text?.isEmpty ?? true ) || ( simpleNoteTextTextView.text?.isEmpty ?? true ) {
                simpleNoteDoneButton.isEnabled = false
            } else {
                simpleNoteDoneButton.isEnabled = true
            }
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton, forEvent event: UIEvent) {
        
        if self.changingSimpleNote != nil {
            
            changeItem()
        } else {
            
            addItem()
        }
    }
    
    func setChangingSimpleNote(changingSimpleNote: SimpleNote) {
        self.changingSimpleNote = changingSimpleNote
    }
    
    private func addItem() -> Void {
        let simpleNote = SimpleNote(
            simpleNoteTitle:     simpleNoteTitleTextField.text!,
            simpleNoteText:      simpleNoteTextTextView.text,
            simpleNoteTimeStamp: simpleNoteCreationTimeStamp)

        SimpleNoteStorage.storage.addSimpleNote(simpleNoteToBeAdded: simpleNote)
        
        performSegue(
            withIdentifier: "backToMasterView",
            sender: self)
    }

    private func changeItem() -> Void {
        
        if let changingSimpleNote = self.changingSimpleNote {
            
            SimpleNoteStorage.storage.changeSimpleNote(
                simpleNoteToBeChanged: SimpleNote(
                    simpleNoteId:        changingSimpleNote.simpleNoteId,
                    simpleNoteTitle:     simpleNoteTitleTextField.text!,
                    simpleNoteText:      simpleNoteTextTextView.text,
                    simpleNoteTimeStamp: simpleNoteCreationTimeStamp)
            )
            
            performSegue(
                withIdentifier: "backToMasterView",
                sender: self)
        } else {
            
            let alert = UIAlertController(
                title: "Ошибка",
                message: "Невозможно изменить",
                preferredStyle: .alert)
            
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default ) { (_) in self.performSegue(
                                              withIdentifier: "backToMasterView",
                                              sender: self)})
            
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        simpleNoteTextTextView.delegate = self
        
        
        if let changingSimpleNote = self.changingSimpleNote {
            
            simpleNoteDateLabel.text = SimpleNoteDateHelper.convertDate(date: Date.init(seconds: simpleNoteCreationTimeStamp))
            simpleNoteTextTextView.text = changingSimpleNote.simpleNoteText
            simpleNoteTitleTextField.text = changingSimpleNote.simpleNoteTitle
           
            simpleNoteDoneButton.isEnabled = true
        } else {
            
            simpleNoteDateLabel.text = SimpleNoteDateHelper.convertDate(date: Date.init(seconds: simpleNoteCreationTimeStamp))
        }
        
        
        simpleNoteTextTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        simpleNoteTextTextView.layer.borderWidth = 1.0
        simpleNoteTextTextView.layer.cornerRadius = 5

        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    func textViewDidChange(_ textView: UITextView) {
        if self.changingSimpleNote != nil {
            
            simpleNoteDoneButton.isEnabled = true
        } else {
           
            if (simpleNoteTitleTextField.text?.isEmpty ?? true ) || ( textView.text?.isEmpty ?? true ) {
                simpleNoteDoneButton.isEnabled = false
            } else {
                simpleNoteDoneButton.isEnabled = true
            }
        }
    }

}
